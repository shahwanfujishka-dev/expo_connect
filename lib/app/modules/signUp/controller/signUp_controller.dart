import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/repositories/registration_repository.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final RegistrationRepository _repository = RegistrationRepository();

  final isValid = false.obs;
  final isSubmitting = false.obs;
  final errorText = RxnString();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void onEmailChanged(String value) {
    errorText.value = null;
    isValid.value = _emailRegex.hasMatch(value.trim());
  }

  Future<void> sendOtpTapped() async {
    if (!isValid.value || isSubmitting.value) return;

    final email = emailController.text.trim();
    isSubmitting.value = true;
    errorText.value = null;

    final result = await _repository.register(email);

    isSubmitting.value = false;

    // CONCENTRATING: Only navigate if the API body says success is true
    if (result.success && result.data != null && result.data!.success == true) {
      final responseData = result.data!;
      
      int duration = 60;
      try {
        if (responseData.data?.otpExpiresAt != null) {
          final expiry = DateTime.parse(responseData.data!.otpExpiresAt);
          duration = expiry.difference(DateTime.now()).inSeconds;
          if (duration < 0) duration = 60;
        }
      } catch (e) {
        // use default
      }

      Get.toNamed(
        Routes.OTP,
        arguments: {
          'contact': email,
          'title': 'Verify your email',
          'subtitle': responseData.message,
          'token': responseData.data?.token,
          'duration': duration,
        },
      );
    } else {
      // Show error from API body message or result error
      errorText.value = result.data?.message ?? result.error?.message ?? 'Registration failed';
      
      Get.snackbar(
        'Signup Failed',
        errorText.value!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
