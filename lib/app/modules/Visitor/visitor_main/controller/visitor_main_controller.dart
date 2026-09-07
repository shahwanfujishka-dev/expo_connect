import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/local/storage_service.dart';

class VisitorMainController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    if (index == 2) {
      Get.toNamed(Routes.VISITOR_QR_SCAN);
      return;
    }
    currentIndex.value = index;
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
