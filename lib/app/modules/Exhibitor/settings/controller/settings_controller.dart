import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/profile_repository.dart';

class SettingsController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final isChangingPassword = false.obs;
  final obscureCurrent = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;

  void toggleCurrent() => obscureCurrent.value = !obscureCurrent.value;
  void toggleNew() => obscureNew.value = !obscureNew.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar(
        "Validation Error",
        "New passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isChangingPassword.value = true;
    final result = await _profileRepository.changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
    );

    isChangingPassword.value = false;

    if (result.success) {
      final successMsg = result.data?['message'] ?? "Password changed successfully";
      
      // 1. Close the bottom sheet first
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }

      // 2. Clear fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      // 3. Show success message
      // We use a slight delay to ensure the keyboard is hidden and the sheet is closed
      // before the snackbar tries to render on the parent screen.
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          "Success",
          successMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      });
    } else {
      Get.snackbar(
        "Error",
        result.error?.message ?? "Failed to change password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        borderRadius: 10,
      );
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}
