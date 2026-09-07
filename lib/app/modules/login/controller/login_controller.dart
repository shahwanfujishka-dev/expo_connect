import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/providers/api_service.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isSubmitting = false.obs;
  final errorText = RxnString();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool get isValid =>
      _emailRegex.hasMatch(emailController.text.trim()) &&
          passwordController.text.trim().isNotEmpty;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> signInTapped() async {
    if (!isValid || isSubmitting.value) return;

    isSubmitting.value = true;
    errorText.value = null;

    final result = await _authRepository.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      remember: 1, // Defaulting to remember for convenience
    );

    isSubmitting.value = false;

    if (result.success && result.data != null && result.data?['success'] == true) {
      final data = result.data?['data'];
      final String? token = data?['auth_token'];
      final String? userType = data?['user']?['user_type'];

      if (token != null && userType != null) {
        // 1. Save session locally
        await StorageService.saveAuthToken(token);
        await StorageService.saveUserType(userType);
        await StorageService.setLoggedIn(true);
        
        // 2. IMPORTANT: Set token in ApiService for immediate use
        ApiService.instance.setToken(token);

        Get.snackbar(
          'Welcome',
          result.data?['message'] ?? 'Logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        // Navigate based on user type
        if (userType == 'exhibitor') {
          Get.offAllNamed(Routes.EXHIBITOR_MAIN);
        } else {
          Get.offAllNamed(Routes.VISITOR_MAIN);
        }
      } else {
        errorText.value = 'Session data missing from server.';
      }
    } else {
      // Robust error parsing
      final dynamic errorData = result.data ?? result.error?.data;
      List<String> messages = [];

      if (errorData is Map && errorData['errors'] != null) {
        final Map<String, dynamic> errors = errorData['errors'];
        errors.forEach((key, value) {
          if (value is List) {
            messages.add("${value.join(', ')}");
          } else {
            messages.add("$value");
          }
        });
      }

      if (messages.isEmpty && errorData is Map && errorData['message'] != null) {
        messages.add(errorData['message'].toString());
      }
      
      if (messages.isEmpty && result.error?.message != null) {
        messages.add(result.error!.message);
      }

      final displayError = messages.isNotEmpty ? messages.join('\n') : 'Login failed. Please check your credentials.';
      errorText.value = displayError;

      Get.snackbar(
        'Login Failed',
        displayError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  void signUpTapped() {
   Get.toNamed(Routes.SIGNUP);
  }

  void forgotPasswordTapped() {
    // TODO: Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
