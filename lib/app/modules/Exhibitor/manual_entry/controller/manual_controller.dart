import 'package:expo_connect/app/data/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/lead_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../exhibitor_appbar/controller/event_dropdown_controller.dart';

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

  @override
  void onInit() {
    super.onInit();
    // Add listeners to clear errors when user types
    nameController.addListener(_clearError);
    emailController.addListener(_clearError);
    phoneController.addListener(_clearError);
    companyNameController.addListener(_clearError);
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
      );

      isSaving.value = false;

      if (result.success && result.data != null && result.data?['success'] == true) {
        Get.snackbar(
          'Success',
          result.data?['message'] ?? 'Lead captured successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        Get.toNamed(
          Routes.LEAD_SAVED,
          arguments: {
            'name': nameController.text.trim(),
            'assignedTo': 'You',
          },
        );
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
