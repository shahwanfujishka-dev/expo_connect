import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/registration_repository.dart';
import '../../../../data/local/storage_service.dart';
import '../../../../data/providers/api_service.dart';

class ExhibitorProfileController extends GetxController {
  final RegistrationRepository _repository = RegistrationRepository();

  final companyNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final customCategoryController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final selectedCategory = Rxn<String>();
  final selectedLogo = Rxn<File>();
  final selectedCountryName = "Select Country".obs;
  final selectedCountryCode = "".obs;

  final isSubmitting = false.obs;
  final errorText = RxnString();
  
  // Real-time password validation
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final passwordsMatch = true.obs;

  // Token passed from Role Selection screen
  final String? token = Get.arguments?['token'];

  static const categories = [
    'Technology',
    'IT',
    'Fashion & Apparel',
    'Food & Beverage',
    'Healthcare',
    'Manufacturing',
    'Finance',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    
    // Add listeners to clear error messages when user types
    companyNameController.addListener(_clearError);
    descriptionController.addListener(_clearError);
    phoneController.addListener(_clearError);
    whatsappController.addListener(_clearError);
    addressController.addListener(_clearError);
    websiteController.addListener(_clearError);
    customCategoryController.addListener(_clearError);
    passwordController.addListener(_clearError);
    confirmPasswordController.addListener(_clearError);

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

  bool get isOtherCategorySelected => selectedCategory.value == 'Other';

  bool get isValid =>
      companyNameController.text.trim().isNotEmpty &&
      descriptionController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty &&
      addressController.text.trim().isNotEmpty &&
      selectedCategory.value != null &&
      (isOtherCategorySelected ? customCategoryController.text.trim().isNotEmpty : true) &&
      selectedCountryCode.value.isNotEmpty &&
      passwordController.text.trim().isNotEmpty && 
      passwordsMatch.value;

  void selectCategory(String value) {
    _clearError();
    selectedCategory.value = value;
    if (value != 'Other') {
      customCategoryController.clear();
    }
  }

  void onCountrySelect(Country country) {
    _clearError();
    selectedCountryName.value = country.name;
    selectedCountryCode.value = country.countryCode; // e.g., 'IN', 'US'
    errorText.value = null;
  }

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        selectedLogo.value = File(image.path);
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

    final category = isOtherCategorySelected 
        ? customCategoryController.text.trim() 
        : selectedCategory.value!;

    final result = await _repository.completeCompanyProfile(
      token: token!,
      name: companyNameController.text.trim(),
      description: descriptionController.text.trim(),
      phone: phoneController.text.trim(),
      whatsapp: whatsappController.text.trim(),
      address: addressController.text.trim(),
      website: websiteController.text.trim(),
      country: selectedCountryCode.value,
      category: category,
      password: passwordController.text.trim(),
      logoPath: selectedLogo.value?.path,
    );

    isSubmitting.value = false;

    if (result.success && result.data != null && result.data?['success'] == true) {
      final responseData = result.data?['data'];
      final authToken = responseData?['auth_token'];
      
      if (authToken != null) {
        // 1. Save session locally
        await StorageService.saveAuthToken(authToken.toString());
        await StorageService.saveUserType('exhibitor');
        await StorageService.setLoggedIn(true);
        
        // 2. IMPORTANT: Set token in ApiService for immediate use without restart
        ApiService.instance.setToken(authToken.toString());
      }

      Get.snackbar(
        'Success',
        result.data?['message'] ?? 'Company profile completed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      Get.offAllNamed(Routes.EXHIBITOR_MAIN);
    } else {
      // 100% Focused Error Parsing
      final dynamic errorData = result.data ?? result.error?.data;
      List<String> messages = [];

      if (errorData is Map && errorData['errors'] != null) {
        final Map<String, dynamic> errors = errorData['errors'];
        errors.forEach((key, value) {
          if (value is List) {
            messages.addAll(value.map((e) => e.toString()));
          } else {
            messages.add(value.toString());
          }
        });
      }

      if (messages.isEmpty && errorData is Map && errorData['message'] != null) {
        messages.add(errorData['message'].toString());
      }
      
      if (messages.isEmpty && result.error?.message != null) {
        messages.add(result.error!.message);
      }

      final displayError = messages.isNotEmpty ? messages.join('\n') : 'Validation failed. Please check your inputs.';
      errorText.value = displayError;

      // Show specific error in snackbar as well
      Get.snackbar(
        'Validation Error',
        displayError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    websiteController.dispose();
    customCategoryController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
