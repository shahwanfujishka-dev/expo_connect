import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../../../data/models/lead.dart';
import '../../../../../data/repositories/lead_repository.dart';
import '../../../../../data/services/endpoints.dart';
import '../../../dashboard/controller/dashBoard_controller.dart';
import '../../lead_pipeline/controller/lead_pipeline_controller.dart';

class LeadNote {
  final int id;
  final String note;
  final String createdByName;
  final DateTime createdAt;

  LeadNote({
    required this.id,
    required this.note,
    required this.createdByName,
    required this.createdAt,
  });

  factory LeadNote.fromJson(Map<String, dynamic> json) {
    return LeadNote(
      id: json['id'],
      note: json['note'] ?? '',
      createdByName: json['created_by']?['name'] ?? 'Unknown',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class LeadTag {
  final int id;
  final String name;
  final String color;

  LeadTag({required this.id, required this.name, required this.color});

  factory LeadTag.fromJson(Map<String, dynamic> json) {
    return LeadTag(
      id: json['id'],
      name: json['name'] ?? '',
      color: json['color'] ?? '#2fae4e',
    );
  }
}

class LeadProduct {
  final int id;
  final String name;

  LeadProduct({required this.id, required this.name});

  factory LeadProduct.fromJson(Map<String, dynamic> json) {
    return LeadProduct(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class LeadFollowUp {
  final int id;
  final DateTime followUpAt;
  final String channel;
  final String remarks;
  final String status;
  final String? createdByName;
  final DateTime? createdAt;

  LeadFollowUp({
    required this.id,
    required this.followUpAt,
    required this.channel,
    required this.remarks,
    required this.status,
    this.createdByName,
    this.createdAt,
  });

  factory LeadFollowUp.fromJson(Map<String, dynamic> json) {
    return LeadFollowUp(
      id: json['id'],
      followUpAt: DateTime.parse(json['follow_up_at']),
      channel: json['channel']?.toString().toLowerCase() ?? 'other',
      remarks: json['notes'] ?? json['remarks'] ?? '', // Mapping from 'notes' as per API response
      status: json['status'] ?? 'pending',
      createdByName: json['created_by']?['name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}

class LeadDocument {
  final int id;
  final String fileName;
  final String fileUrl;
  final String fileType;

  LeadDocument({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
  });

  factory LeadDocument.fromJson(Map<String, dynamic> json) {
    final String url = json['url'] ?? '';
    final String fullUrl = url.startsWith('http') ? url : '${Endpoints.baseUrl}/public/storage/$url';

    return LeadDocument(
      id: json['id'],
      fileName: json['name'] ?? 'Document',
      fileUrl: fullUrl,
      fileType: json['file_type'] ?? 'image',
    );
  }
}

class LeadStatus {
  final int id;
  final String name;
  final String slug;

  LeadStatus({required this.id, required this.name, required this.slug});

  factory LeadStatus.fromJson(Map<String, dynamic> json) {
    return LeadStatus(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class SalesPerson {
  final int id;
  final String name;
  final String userType;

  SalesPerson({required this.id, required this.name, required this.userType});

  factory SalesPerson.fromJson(Map<String, dynamic> json) {
    return SalesPerson(
      id: json['id'],
      name: json['name'] ?? '',
      userType: json['user_type'] ?? '',
    );
  }
}

class LeadDetailsController extends GetxController {
  final LeadRepository _leadRepository = LeadRepository();

  late Lead lead;
  final isLoading = false.obs;
  final detailedLead = Rxn<Lead>();

  final notesController = TextEditingController();
  final tagsController = TextEditingController();
  final productsController = TextEditingController();

  // Follow-up Controllers
  final followUpRemarksController = TextEditingController();
  final selectedFollowUpDate = Rxn<DateTime>();
  final selectedChannel = 'email'.obs;
  final isSubmittingFollowUp = false.obs;
  final isDeletingFollowUp = 0.obs;
  final isLoadingFollowUpDetails = false.obs;
  final editingFollowUpId = RxnInt();

  // Tabs
  final selectedTabIndex = 0.obs;
  final tabs = ['Note', 'Tags & Product', 'Follow Up', 'Documents'];

  // Data Lists
  final notes = <LeadNote>[].obs;
  final isSubmittingNote = false.obs;
  final tags = <LeadTag>[].obs;
  final products = <LeadProduct>[].obs;
  final followUps = <LeadFollowUp>[].obs;
  final documents = <LeadDocument>[].obs;

  final isSubmittingTag = false.obs;
  final isSubmittingProduct = false.obs;
  final isDeletingTag = 0.obs;
  final isDeletingProduct = 0.obs;
  final isUploadingDocument = false.obs;
  final isDeletingDocument = 0.obs;

  // Status and Sales Person
  final leadStatuses = <LeadStatus>[].obs;
  final salesPersons = <SalesPerson>[].obs;
  final selectedStatusId = RxnInt();
  final selectedSalesPersonId = RxnInt();
  final isUpdatingStatus = false.obs;
  final isAssigningSalesPerson = false.obs;

  @override
  void onInit() {
    super.onInit();
    lead = Get.arguments as Lead;
    fetchLeadDetails();
    fetchDropdownData();
  }

  Future<void> fetchLeadDetails() async {
    isLoading.value = true;
    final result = await _leadRepository.getLeadDetails(lead.id);

    if (result.success) {
      final data = result.data?['data'];
      if (data != null) {
        final updatedLead = lead.copyWith(
          email: data['email'],
          phone: data['phone'],
          whatsapp: data['whatsapp'],
          title: data['designation'],
          company: data['company_name'],
          status_name: data['status_name'],
          status_color: data['status_color'],
        );
        detailedLead.value = updatedLead;
        lead = updatedLead;

        // Initialize current status and assigned person based on the provided JSON structure
        if (data['status'] != null) {
          selectedStatusId.value = int.tryParse(data['status'].toString());
        }
        if (data['assigned_to'] != null && data['assigned_to'] is Map) {
          selectedSalesPersonId.value = int.tryParse(data['assigned_to']['id'].toString());
        }

        if (data['notes'] != null && data['notes'] is List) {
          notes.assignAll((data['notes'] as List).map((n) => LeadNote.fromJson(n)).toList());
        }

        if (data['tags'] != null && data['tags'] is List) {
          tags.assignAll((data['tags'] as List).map((t) => LeadTag.fromJson(t)).toList());
        }

        if (data['products'] != null && data['products'] is List) {
          products.assignAll((data['products'] as List).map((p) => LeadProduct.fromJson(p)).toList());
        }

        if (data['follow_ups'] != null && data['follow_ups'] is List) {
          followUps.assignAll((data['follow_ups'] as List).map((f) => LeadFollowUp.fromJson(f)).toList());
        }

        if (data['documents'] != null && data['documents'] is List) {
          documents.assignAll((data['documents'] as List).map((d) => LeadDocument.fromJson(d)).toList());
        }
      }
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to fetch lead details");
    }
    isLoading.value = false;
  }

  Future<void> fetchDropdownData() async {
    final statusResult = await _leadRepository.getLeadStatuses();
    if (statusResult.success && statusResult.data?['data'] != null) {
      leadStatuses.assignAll((statusResult.data!['data'] as List).map((s) => LeadStatus.fromJson(s)).toList());
    }

    final salesResult = await _leadRepository.getSalesPersons();
    if (salesResult.success && salesResult.data?['data'] != null) {
      salesPersons.assignAll((salesResult.data!['data'] as List).map((s) => SalesPerson.fromJson(s)).toList());
    }
  }

  Future<void> updateStatus(int? statusId) async {
    if (statusId == null) return;
    isUpdatingStatus.value = true;
    final result = await _leadRepository.updateLeadStatus(lead.id, statusId);
    if (result.success) {
      selectedStatusId.value = statusId;
      await fetchLeadDetails(); // Refresh to get new status_name and status_color
      _refreshOtherScreens();
      Get.snackbar("Success", "Lead status updated successfully");
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to update status");
    }
    isUpdatingStatus.value = false;
  }

  Future<void> assignSalesPerson(int? salesPersonId) async {
    if (salesPersonId == null) return;
    isAssigningSalesPerson.value = true;
    final result = await _leadRepository.assignSalesPerson(lead.id, salesPersonId);
    if (result.success) {
      selectedSalesPersonId.value = salesPersonId;
      await fetchLeadDetails();
      _refreshOtherScreens();
      Get.snackbar("Success", "Sales person assigned successfully");
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to assign sales person");
    }
    isAssigningSalesPerson.value = false;
  }

  void _refreshOtherScreens() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
    if (Get.isRegistered<LeadPipelineController>()) {
      Get.find<LeadPipelineController>().fetchLeads();
    }
  }

  // Document Methods
  Future<void> pickAndUploadDocument() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isUploadingDocument.value = true;
      final result = await _leadRepository.submitDocuments(lead.id, File(image.path));

      if (result.success) {
        // Refresh details after upload to get updated document list
        await fetchLeadDetails();
        Get.snackbar("Success", "Document uploaded successfully");
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to upload document");
      }
      isUploadingDocument.value = false;
    }
  }

  Future<void> deleteDocument(int documentId) async {
    isDeletingDocument.value = documentId;
    final result = await _leadRepository.removeDocument(lead.id, documentId);

    if (result.success) {
      // Refresh details after deletion
      await fetchLeadDetails();
      Get.snackbar("Success", "Document removed successfully");
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to remove document");
    }
    isDeletingDocument.value = 0;
  }

  Future<void> viewDocument(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open document");
    }
  }

  // Note Methods
  Future<void> submitNote() async {
    final noteText = notesController.text.trim();
    if (noteText.isEmpty) return;
    isSubmittingNote.value = true;
    final result = await _leadRepository.submitNote(lead.id, noteText);
    if (result.success) {
      await fetchLeadDetails();
      notesController.clear();
      Get.snackbar("Success", "Note added successfully");
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to add note");
    }
    isSubmittingNote.value = false;
  }

  // Tag Methods
  Future<void> submitTag() async {
    final tagText = tagsController.text.trim();
    if (tagText.isEmpty) return;
    isSubmittingTag.value = true;
    final result = await _leadRepository.submitTags(lead.id, tagText);
    if (result.success) {
      await fetchLeadDetails();
      tagsController.clear();
      Get.snackbar("Success", "Tags updated successfully");
    }
    isSubmittingTag.value = false;
  }

  Future<void> deleteTag(int tagId) async {
    isDeletingTag.value = tagId;
    final result = await _leadRepository.removeTag(lead.id, tagId);
    if (result.success) {
      await fetchLeadDetails();
    }
    isDeletingTag.value = 0;
  }

  // Product Methods
  Future<void> submitProduct() async {
    final productText = productsController.text.trim();
    if (productText.isEmpty) return;
    isSubmittingProduct.value = true;
    final result = await _leadRepository.submitProducts(lead.id, productText);
    if (result.success) {
      await fetchLeadDetails();
      productsController.clear();
      Get.snackbar("Success", "Products updated successfully");
    }
    isSubmittingProduct.value = false;
  }

  Future<void> deleteProduct(int productId) async {
    isDeletingProduct.value = productId;
    final result = await _leadRepository.removeProduct(lead.id, productId);
    if (result.success) {
      await fetchLeadDetails();
    }
    isDeletingProduct.value = 0;
  }

  // Follow-up Methods
  Future<void> submitFollowUp() async {
    if (selectedFollowUpDate.value == null) {
      Get.snackbar("Error", "Please select a date and time");
      return;
    }
    final remarks = followUpRemarksController.text.trim();
    if (remarks.isEmpty) {
      Get.snackbar("Error", "Please enter remarks");
      return;
    }

    isSubmittingFollowUp.value = true;
    final followUpAt = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(selectedFollowUpDate.value!);

    if (editingFollowUpId.value != null) {
      final result = await _leadRepository.updateFollowUp(
        leadId: lead.id,
        followUpId: editingFollowUpId.value!,
        followUpAt: followUpAt,
        channel: selectedChannel.value,
        remarks: remarks,
        status: 'pending',
      );

      if (result.success) {
        await fetchLeadDetails();
        cancelEditingFollowUp();
        Get.snackbar("Success", "Follow-up updated successfully");
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to update follow-up");
      }
    } else {
      final result = await _leadRepository.submitFollowUp(
        leadId: lead.id,
        followUpAt: followUpAt,
        channel: selectedChannel.value,
        remarks: remarks,
      );

      if (result.success) {
        await fetchLeadDetails();
        followUpRemarksController.clear();
        selectedFollowUpDate.value = null;
        Get.snackbar("Success", "Follow-up added successfully");
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to add follow-up");
      }
    }
    isSubmittingFollowUp.value = false;
  }

  Future<void> fetchAndStartEditingFollowUp(int followUpId) async {
    isLoadingFollowUpDetails.value = true;
    final result = await _leadRepository.showFollowUp(lead.id, followUpId);

    if (result.success && result.data != null) {
      final details = LeadFollowUp.fromJson(result.data!['data']);
      editingFollowUpId.value = details.id;
      selectedFollowUpDate.value = details.followUpAt;

      final normalizedChannel = details.channel.toLowerCase();
      final allowedChannels = ['email', 'call', 'whatsapp', 'meeting', 'other'];
      selectedChannel.value = allowedChannels.contains(normalizedChannel) ? normalizedChannel : 'other';

      followUpRemarksController.text = details.remarks;
      selectedTabIndex.value = 2; // Follow Up tab
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to fetch follow-up details");
    }
    isLoadingFollowUpDetails.value = false;
  }

  void cancelEditingFollowUp() {
    editingFollowUpId.value = null;
    selectedFollowUpDate.value = null;
    selectedChannel.value = 'email';
    followUpRemarksController.clear();
  }

  Future<void> deleteFollowUp(int followUpId) async {
    isDeletingFollowUp.value = followUpId;
    final result = await _leadRepository.removeFollowUp(lead.id, followUpId);
    if (result.success) {
      await fetchLeadDetails();
      if (editingFollowUpId.value == followUpId) {
        cancelEditingFollowUp();
      }
      Get.snackbar("Success", "Follow-up removed successfully");
    }
    isDeletingFollowUp.value = 0;
  }

  Future<void> updateFollowUpStatus(LeadFollowUp followUp, String newStatus) async {
    final followUpAt = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(followUp.followUpAt);
    final result = await _leadRepository.updateFollowUp(
      leadId: lead.id,
      followUpId: followUp.id,
      followUpAt: followUpAt,
      channel: followUp.channel,
      remarks: followUp.remarks,
      status: newStatus,
    );

    if (result.success) {
      await fetchLeadDetails();
      Get.snackbar("Success", "Follow-up status updated");
    }
  }

  Future<void> showFollowUpDetails(int followUpId) async {
    isLoadingFollowUpDetails.value = true;
    final result = await _leadRepository.showFollowUp(lead.id, followUpId);
    isLoadingFollowUpDetails.value = false;

    if (result.success && result.data != null) {
      final details = LeadFollowUp.fromJson(result.data!['data']);

      Get.dialog(
        AlertDialog(
          title: const Text('Follow-up Details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Channel', details.channel.toUpperCase()),
              _detailRow('Date', DateFormat('MMM dd, yyyy - hh:mm a').format(details.followUpAt)),
              _detailRow('Remarks', details.remarks),
              _detailRow('Status', details.status.toUpperCase()),
              _detailRow('Created By', details.createdByName ?? 'Unknown'),
              if (details.createdAt != null)
                _detailRow('Created At', DateFormat('MMM dd, yyyy').format(details.createdAt!)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),
            TextButton(
              onPressed: () {
                Get.back();
                fetchAndStartEditingFollowUp(details.id);
              },
              child: const Text('Edit', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
    }
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // Communication Methods
  Future<void> callLead() async {
    final phone = detailedLead.value?.phone ?? lead.phone;
    if (phone == null || phone.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  Future<void> whatsappLead() async {
    final whatsapp = detailedLead.value?.whatsapp ?? detailedLead.value?.phone ?? lead.phone;
    if (whatsapp == null || whatsapp.isEmpty) return;
    String cleanNumber = whatsapp.replaceAll(RegExp(r'\D'), '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber");
    if (await canLaunchUrl(whatsappUri)) await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  Future<void> emailLead() async {
    final email = detailedLead.value?.email ?? lead.email;
    if (email == null || email.isEmpty) return;
    final Uri emailUri = Uri(scheme: 'mailto', path: email, query: 'subject=Expo Connect Follow-up');
    if (await canLaunchUrl(emailUri)) await launchUrl(emailUri);
  }

  @override
  void onClose() {
    notesController.dispose();
    tagsController.dispose();
    productsController.dispose();
    followUpRemarksController.dispose();
    super.onClose();
  }
}
