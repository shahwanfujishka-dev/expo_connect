import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../routes/app_routes.dart';

class ExhibitorNavController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final ProfileRepository _profileRepository = ProfileRepository();
  
  final currentIndex = 0.obs;
  final isDrawerOpen = false.obs;

  // Profile data for drawer
  final userName = "User".obs;
  final userEmail = "".obs;
  final userCompany = "".obs;
  final userAvatar = RxnString();
  final isLoadingProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoadingProfile.value = true;
    final result = await _profileRepository.getMyProfile();
    if (result.success) {
      final data = result.data?['data'];
      if (data != null) {
        userName.value = data['name'] ?? "User";
        userEmail.value = data['email'] ?? "";
        userCompany.value = data['company'] ?? "";
        userAvatar.value = data['avatar'];
      }
    }
    isLoadingProfile.value = false;
  }

  void changePage(int index) {
    if (index == 2) {
      Get.toNamed(Routes.LEAD_CAPTURE);
      return;
    }
    currentIndex.value = index;
  }

  void toggleDrawer() => isDrawerOpen.value = !isDrawerOpen.value;
  void closeDrawer() => isDrawerOpen.value = false;

  Future<void> logout() async {
    closeDrawer();
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
              Get.back(); // Close dialog

              // Show loading
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              // Call Logout API
              await _authRepository.logout();

              // Clear Local Storage
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
