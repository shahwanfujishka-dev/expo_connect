import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/repositories/registration_repository.dart';

enum AttendeeRole { exhibitor, visitor }

class RoleController extends GetxController {
  final RegistrationRepository _repository = RegistrationRepository();
  
  final selectedRole = Rxn<AttendeeRole>();
  final isLoading = false.obs;

  // Token passed from OTP screen
  final String? token = Get.arguments?['token'];

  void select(AttendeeRole role) => selectedRole.value = role;

  Future<void> continueTapped() async {
    final role = selectedRole.value;
    if (role == null) return;
    
    if (token == null) {
      Get.snackbar(
        'Error',
        'Session expired. Please start registration again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final userType = role == AttendeeRole.exhibitor ? 'exhibitor' : 'visitor';
    final result = await _repository.selectUserType(token!, userType);

    isLoading.value = false;

    if (result.success && result.data != null && result.data?['success'] == true) {
      Get.snackbar(
        'Success',
        result.data?['message'] ?? 'Role selected successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      // Navigate based on role
      switch (role) {
        case AttendeeRole.exhibitor:
          Get.offAllNamed(Routes.EXHIBITOR_PROFILE, arguments: {'token': token});
          break;
        case AttendeeRole.visitor:
          // Navigate to the NEW Visitor Complete Profile screen
          Get.offAllNamed(Routes.VISITOR_COMPLETE_PROFILE, arguments: {'token': token});
          break;
      }
    } else {
      Get.snackbar(
        'Error',
        result.data?['message'] ?? result.error?.message ?? 'Failed to select role.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
