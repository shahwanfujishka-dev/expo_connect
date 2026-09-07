import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/repositories/registration_repository.dart';

class OtpController extends GetxController {
  static const otpLength = 6;
  
  final RegistrationRepository _repository = RegistrationRepository();

  // Arguments passed from Signup
  final String contact = Get.arguments?['contact'] ?? '';
  final String title = Get.arguments?['title'] ?? 'Verify email';
  final String subtitle = Get.arguments?['subtitle'] ?? 'Enter the code sent to your email';
  final String? token = Get.arguments?['token'];
  final int initialDuration = (Get.arguments?['duration'] as int?) ?? 60;

  final digitControllers = List.generate(otpLength, (_) => TextEditingController());
  final focusNodes = List.generate(otpLength, (_) => FocusNode());

  final secondsLeft = 0.obs;
  final isVerifying = false.obs;
  final isResending = false.obs;
  final errorText = RxnString();
  Timer? _timer;

  bool get isComplete => digitControllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void onInit() {
    super.onInit();
    startTimer(initialDuration);
  }

  void startTimer(int duration) {
    _timer?.cancel();
    secondsLeft.value = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value == 0) {
        t.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  void onDigitChanged(int index, String value) {
    errorText.value = null;
    if (value.isNotEmpty && index < otpLength - 1) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    if (isComplete) verifyTapped();
  }

  Future<void> verifyTapped() async {
    if (!isComplete || isVerifying.value) return;

    final otp = digitControllers.map((c) => c.text).join();
    
    if (token == null) {
      errorText.value = 'Session token missing. Please try signing up again.';
      return;
    }

    isVerifying.value = true;
    errorText.value = null;

    final result = await _repository.verifyOtp(token!, otp);

    isVerifying.value = false;

    // CONCENTRATING: Check both API Result and the success field in the body
    if (result.success && result.data != null && result.data?['success'] == true) {
      Get.snackbar(
        'Success',
        result.data?['message'] ?? 'OTP verified successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.ROLE_SELECTION, arguments: {'token': token});
    } else {
      errorText.value = result.data?['message'] ?? result.error?.message ?? 'Invalid OTP. Please try again.';
      
      Get.snackbar(
        'Verification Failed',
        errorText.value!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

      // Clear OTP fields on error so user can re-enter
      for (var controller in digitControllers) {
        controller.clear();
      }
      focusNodes[0].requestFocus();
    }
  }

  Future<void> resendTapped() async {
    if (secondsLeft.value > 0 || isResending.value || token == null) return;

    isResending.value = true;
    final result = await _repository.resendOtp(token!);
    isResending.value = false;

    if (result.success && result.data?['success'] == true) {
      Get.snackbar(
        'Success',
        result.data?['message'] ?? 'A new OTP has been sent to your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      // Calculate new duration from otp_expires_at
      int duration = 60;
      try {
        final expiryStr = result.data?['data']?['otp_expires_at'];
        if (expiryStr != null) {
          final expiry = DateTime.parse(expiryStr);
          duration = expiry.difference(DateTime.now()).inSeconds;
          if (duration < 0) duration = 60;
        }
      } catch (e) {
        // use default 60
      }

      startTimer(duration);
    } else {
      Get.snackbar(
        'Error',
        result.data?['message'] ?? result.error?.message ?? 'Failed to resend OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in digitControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
