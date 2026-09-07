import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/registration_repository.dart';
import '../../../../data/local/storage_service.dart';
import '../../../../data/providers/api_service.dart';

class VisitorCompleteProfileController extends GetxController {
  final RegistrationRepository _repository = RegistrationRepository();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final selectedAvatar = Rxn<File>();
  final isSubmitting = false.obs;
  final errorText = RxnString();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final passwordsMatch = true.obs;

  // Token passed from Role Selection screen
  final String? token = Get.arguments?['token'];

  @override
  void onInit() {
    super.onInit();

    // Clear error when typing
    nameController.addListener(_clearError);
    phoneController.addListener(_clearError);
    whatsappController.addListener(_clearError);
    passwordController.addListener(_clearError);
    confirmPasswordController.addListener(_clearError);

    // Real-time password validation
    passwordController.addListener(_validatePasswords);
    confirmPasswordController.addListener(_validatePasswords);
  }

  void _clearError() {
    if (errorText.value != null) errorText.value = null;
  }

  void _validatePasswords() {
    if (confirmPasswordController.text.isEmpty) {
      passwordsMatch.value = true;
    } else {
      passwordsMatch.value = passwordController.text == confirmPasswordController.text;
    }
  }

  bool get isValid =>
      nameController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty &&
      passwordsMatch.value;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        selectedAvatar.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> saveTapped() async {
    if (!isValid) {
      if (!passwordsMatch.value) {
        errorText.value = "Passwords do not match";
      } else if (passwordController.text.isEmpty) {
        errorText.value = "Password is required";
      } else {
        errorText.value = "Please fill in all required fields (*) before continuing.";
      }
      return;
    }

    if (token == null) {
      Get.snackbar('Error', 'Session expired. Please restart registration.');
      return;
    }

    isSubmitting.value = true;
    errorText.value = null;

    final result = await _repository.completeVisitorProfile(
      token: token!,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      whatsapp: whatsappController.text.trim(),
      password: passwordController.text.trim(),
      avatarPath: selectedAvatar.value?.path,
    );

    isSubmitting.value = false;

    if (result.success && result.data != null && result.data?['success'] == true) {
      final responseData = result.data?['data'];
      final authToken = responseData?['auth_token'];

      if (authToken != null) {
        // 1. Save session locally
        await StorageService.saveAuthToken(authToken.toString());
        await StorageService.saveUserType('visitor');
        await StorageService.setLoggedIn(true);

        // 2. Set token in ApiService for immediate use
        ApiService.instance.setToken(authToken.toString());
      }

      Get.snackbar(
        'Success',
        result.data?['message'] ?? 'Profile completed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.VISITOR_MAIN);
    } else {
      // Focused Error Parsing
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

      final displayError = messages.isNotEmpty ? messages.join('\n') : 'Validation failed. Please check your inputs.';
      errorText.value = displayError;

      Get.snackbar(
        'Validation Failed',
        displayError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
