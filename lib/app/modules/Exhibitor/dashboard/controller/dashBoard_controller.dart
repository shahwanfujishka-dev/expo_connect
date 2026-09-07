import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/lead.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/local/storage_service.dart';
import '../../../../data/repositories/auth_repository.dart';

class DashboardStats {
  const DashboardStats({
    required this.leadsToday,
    required this.hotLeads,
    required this.conversionPercent,
  });

  final int leadsToday;
  final int hotLeads;
  final int conversionPercent;
}

class DashboardController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final companyName = 'Nova Textiles'.obs; // TODO: pull from company profile
  final isLoading = true.obs;
  final stats = Rxn<DashboardStats>();
  final recentLeads = <Lead>[].obs;
  final navIndex = 0.obs;

  final isDrawerOpen = false.obs;

  void openDrawer() => isDrawerOpen.value = true;
  void closeDrawer() => isDrawerOpen.value = false;
  void toggleDrawer() => isDrawerOpen.value = !isDrawerOpen.value;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    stats.value = const DashboardStats(
      leadsToday: 42,
      hotLeads: 11,
      conversionPercent: 18,
    );

    recentLeads.assignAll(const [
      Lead(
        id: '1',
        name: 'Rahul Mehta',
        title: 'Marketing Head, Nova Textiles',
        company: 'Nova Textiles',
        temperature: LeadTemperature.hot,
      ),
      Lead(
        id: '2',
        name: 'Sara Khan',
        title: 'Procurement, Delta Corp',
        company: 'Delta Corp',
        temperature: LeadTemperature.warm,
      ),
    ]);

    isLoading.value = false;
  }

  void onNavTap(int index) {
    if (index == 2) {
      Get.toNamed(Routes.LEAD_CAPTURE);
      return;
    }

    if (navIndex.value == index) return;
    navIndex.value = index;

    switch (index) {
      case 0:
        Get.offNamed(Routes.DASHBOARD);
        break;
      case 1:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }

  void scanQrTapped() => Get.toNamed(Routes.QR_SCAN);
  void scanCardTapped() => Get.toNamed(Routes.BUSINESS_CARD_SCAN);
  void manualEntryTapped() => Get.toNamed(Routes.MANUAL_ENTRY);

  Future<void> logoutTapped() async {
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
              
              // Optional: show loading
              Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
              
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
