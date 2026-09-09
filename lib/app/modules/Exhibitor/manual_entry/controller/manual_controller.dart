import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/lead_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../exhibitor_appbar/controller/event_dropdown_controller.dart';
import '../../dashboard/controller/dashBoard_controller.dart';

class ManualEntryController extends GetxController {
  final LeadRepository _leadRepository = LeadRepository();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final websiteController = TextEditingController();
  final whatsappController = TextEditingController();
  final addressController = TextEditingController();
  final companyNameController = TextEditingController();
  final designationController = TextEditingController();

  final isSaving = false.obs;
  final errorText = RxnString();
  
  // Default source is 'manual'
  String source = 'manual';

  String get title {
    if (source == 'qr') return 'QR Lead Scan';
    if (source == 'card_scan') return 'Card Lead Scan';
    return 'Manual Entry';
  }

  @override
  void onInit() {
    super.onInit();
    _fillFromArguments();
    // Add listeners to clear errors when user types
    nameController.addListener(_clearError);
    emailController.addListener(_clearError);
    phoneController.addListener(_clearError);
    companyNameController.addListener(_clearError);
  }

  void _fillFromArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final Map args = Get.arguments;
      nameController.text = args['name']?.toString() ?? '';
      emailController.text = args['email']?.toString() ?? '';
      phoneController.text = args['phone']?.toString() ?? '';
      whatsappController.text = args['whatsapp']?.toString() ?? '';
      designationController.text = args['designation']?.toString() ?? '';
      companyNameController.text = args['company_name']?.toString() ?? '';
      addressController.text = args['address']?.toString() ?? '';
      websiteController.text = args['website']?.toString() ?? '';
      
      // Update source if passed in arguments
      if (args.containsKey('source')) {
        source = args['source'].toString();
      }
    }
  }

  void _clearError() {
    if (errorText.value != null) errorText.value = null;
  }

  bool get isValid =>
      nameController.text.trim().isNotEmpty &&
      emailController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty &&
      companyNameController.text.trim().isNotEmpty;

  Future<void> saveLeadTapped() async {
    if (!isValid) {
      errorText.value = "Please fill in all required fields (*)";
      return;
    }

    // Get expo_id from dropdown controller
    int? expoId;
    if (Get.isRegistered<EventDropdownController>()) {
      expoId = Get.find<EventDropdownController>().selectedEvent.value?.id;
    }

    if (expoId == null) {
      errorText.value = "Please select an event from the dashboard first";
      Get.snackbar("Error", errorText.value!);
      return;
    }

    isSaving.value = true;
    errorText.value = null;

    try {
      final result = await _leadRepository.captureManualLead(
        expoId: expoId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        website: websiteController.text.trim(),
        whatsapp: whatsappController.text.trim(),
        address: addressController.text.trim(),
        companyName: companyNameController.text.trim(),
        designation: designationController.text.trim(),
        source: source,
      );

      isSaving.value = false;

      if (result.success && result.data != null && result.data?['success'] == true) {
        Get.snackbar(
          'Success',
          result.data?['message'] ?? 'Lead captured successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Refresh dashboard data if controller exists
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().loadDashboard();
        }

        // Navigate back to dashboard and clear stack
        Get.offAllNamed(Routes.EXHIBITOR_MAIN); // Using EXHIBITOR_MAIN as it usually contains the dashboard with nav
      } else {
        // Robust Error Parsing
        final dynamic errorData = result.data ?? result.error?.data;
        List<String> messages = [];

        if (errorData is Map && errorData['errors'] != null) {
          final Map<String, dynamic> errors = errorData['errors'];
          errors.forEach((key, value) {
            if (value is List) {
              messages.add("$key: ${value.join(', ')}");
            } else {
              messages.add("$key: $value");
            }
          });
        }

        if (messages.isEmpty && errorData is Map && errorData['message'] != null) {
          messages.add(errorData['message'].toString());
        }
        
        if (messages.isEmpty && result.error?.message != null) {
          messages.add(result.error!.message);
        }

        final displayError = messages.isNotEmpty ? messages.join('\n') : 'Failed to capture lead';
        errorText.value = displayError;

        Get.snackbar(
          'Capture Failed',
          displayError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      isSaving.value = false;
      errorText.value = 'An unexpected error occurred';
      Get.snackbar('Error', errorText.value!);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    companyNameController.dispose();
    designationController.dispose();
    super.onClose();
  }
}
