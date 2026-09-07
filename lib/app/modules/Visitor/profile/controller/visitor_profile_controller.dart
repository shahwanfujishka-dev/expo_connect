import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/local/storage_service.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../routes/app_routes.dart';

class VisitorProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  
  final name = "Abha Khan".obs;
  final company = "Super Merch Group".obs;
  final role = "Senior Buyer".obs;
  final email = "abha.khan@example.com".obs;

  void shareCard() {
    Get.snackbar("Share", "Sharing digital business card...");
  }

  void saveToGallery() {
    Get.snackbar("Save", "QR Code saved to gallery");
  }

  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close confirmation dialog
              
              // Show loading indicator
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );
              
              // Call Logout API
              await _authRepository.logout();
              
              // Clear local session data
              await StorageService.logout();

              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
