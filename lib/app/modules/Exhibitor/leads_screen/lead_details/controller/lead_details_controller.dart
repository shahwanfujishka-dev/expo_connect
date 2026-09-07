import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/models/lead.dart';
import '../../../../../data/repositories/lead_repository.dart';

class LeadDetailsController extends GetxController {
  final LeadRepository _leadRepository = LeadRepository();
  
  late Lead lead;
  final isLoading = false.obs;
  final detailedLead = Rxn<Lead>();
  final notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    lead = Get.arguments as Lead;
    fetchLeadDetails();
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
        );
        detailedLead.value = updatedLead;
        // Optionally update the local 'lead' variable if you want to reflect changes immediately
        lead = updatedLead;
      }
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to fetch lead details");
    }
    isLoading.value = false;
  }

  Future<void> callLead() async {
    final phone = detailedLead.value?.phone ?? lead.phone;
    if (phone == null || phone.isEmpty) {
      Get.snackbar('Error', 'Phone number not available');
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar('Error', 'Could not launch dialer');
    }
  }

  Future<void> whatsappLead() async {
    final whatsapp = detailedLead.value?.whatsapp ?? detailedLead.value?.phone ?? lead.phone;
    if (whatsapp == null || whatsapp.isEmpty) {
      Get.snackbar('Error', 'WhatsApp number not available');
      return;
    }
    
    String cleanNumber = whatsapp.replaceAll(RegExp(r'\D'), '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber");
    
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'WhatsApp is not installed or could not be opened');
    }
  }

  Future<void> emailLead() async {
    final email = detailedLead.value?.email ?? lead.email;
    if (email == null || email.isEmpty) {
      Get.snackbar('Error', 'Email address not available');
      return;
    }
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Expo Connect Follow-up',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('Error', 'Could not launch email app');
    }
  }
}
