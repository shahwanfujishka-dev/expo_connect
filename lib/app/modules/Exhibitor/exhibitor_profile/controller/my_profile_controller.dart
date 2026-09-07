import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/repositories/profile_repository.dart';
import '../../ExhibitorNav/ExhibitorNavController.dart';

class MyProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ImagePicker _picker = ImagePicker();

  final isLoading = true.obs;
  final isUpdating = false.obs;
  final isChangingPassword = false.obs;
  final isUploadingAvatar = false.obs;
  final profileData = Rxn<Map<String, dynamic>>();
  final qrData = Rxn<Map<String, dynamic>>();

  // Controllers for editing profile
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Controllers for changing password
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    
    final results = await Future.wait([
      _profileRepository.getMyProfile(),
      _profileRepository.getMyQrCode(),
    ]);

    final profileResult = results[0];
    final qrResult = results[1];

    if (profileResult.success) {
      profileData.value = profileResult.data?['data'];
      _updateTextControllers();
    } else {
      Get.snackbar("Error", profileResult.error?.message ?? "Failed to load profile");
    }

    if (qrResult.success) {
      qrData.value = qrResult.data?['data'];
    }

    isLoading.value = false;
  }

  void _updateTextControllers() {
    if (profileData.value != null) {
      nameController.text = profileData.value!['name'] ?? "";
      emailController.text = profileData.value!['email'] ?? "";
      phoneController.text = profileData.value!['phone'] ?? "";
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar(
        "Validation Error", 
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    isUpdating.value = true;
    final result = await _profileRepository.updateMyProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    if (result.success) {
      profileData.value = result.data?['data'];
      
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        "Success", 
        result.data?['message'] ?? "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      
      try {
        final navCtrl = Get.find<ExhibitorNavController>();
        navCtrl.fetchProfile();
      } catch (_) {}
      
    } else {
      Get.snackbar(
        "Error", 
        result.error?.message ?? "Update failed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
    isUpdating.value = false;
  }

  Future<void> pickAndUploadAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      isUploadingAvatar.value = true;
      
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await _profileRepository.updateAvatar(image.path);
      
      Get.back(); // Close loading dialog
      isUploadingAvatar.value = false;

      if (result.success) {
        profileData.value = result.data?['data'];
        
        Get.snackbar(
          "Success", 
          result.data?['message'] ?? "Profile picture updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        try {
          final navCtrl = Get.find<ExhibitorNavController>();
          navCtrl.fetchProfile();
        } catch (_) {}
      } else {
        Get.snackbar(
          "Error", 
          result.error?.message ?? "Failed to upload avatar",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> removeAvatar() async {
    isUploadingAvatar.value = true;
    
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final result = await _profileRepository.removeAvatar();
    
    Get.back(); // Close loading dialog
    isUploadingAvatar.value = false;

    if (result.success) {
      profileData.value = result.data?['data'];
      
      Get.snackbar(
        "Success", 
        result.data?['message'] ?? "Profile picture removed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      try {
        final navCtrl = Get.find<ExhibitorNavController>();
        navCtrl.fetchProfile();
      } catch (_) {}
    } else {
      Get.snackbar(
        "Error", 
        result.error?.message ?? "Failed to remove avatar",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty || 
        newPasswordController.text.isEmpty || 
        confirmNewPasswordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar("Error", "New passwords do not match", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isChangingPassword.value = true;
    final result = await _profileRepository.changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
    );

    if (result.success) {
      if (Get.isBottomSheetOpen ?? false) Get.back();
      
      Get.snackbar(
        "Success", 
        result.data?['message'] ?? "Password changed successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
      );
      
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();
    } else {
      Get.snackbar(
        "Error", 
        result.error?.message ?? "Failed to change password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
    isChangingPassword.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}
