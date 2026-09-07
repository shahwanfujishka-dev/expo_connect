import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/lead.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/local/storage_service.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/lead_repository.dart';

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
  final LeadRepository _leadRepository = LeadRepository();
  
  final companyName = 'Exhibitor'.obs; 
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
    
    final result = await _leadRepository.getDashboardData();

    if (result.success) {
      final data = result.data?['data'];
      if (data != null) {
        stats.value = DashboardStats(
          leadsToday: data['total_lead'] ?? 0,
          hotLeads: data['hot_lead'] ?? 0,
          conversionPercent: (data['conversion_rate'] as num?)?.toInt() ?? 0,
        );

        final List<dynamic> leadsJson = data['recent_leads'] ?? [];
        recentLeads.assignAll(leadsJson.map((json) {
          return Lead(
            id: json['id'].toString(),
            name: json['name'] ?? '',
            title: json['designation'] ?? '',
            company: json['company_name'] ?? '',
            temperature: _mapStatusToTemperature(json['status']),
          );
        }).toList());
      }
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to load dashboard");
    }

    isLoading.value = false;
  }

  LeadTemperature _mapStatusToTemperature(dynamic status) {
    // Assuming status 1 is Hot for now, adjust based on actual logic
    if (status == 1) return LeadTemperature.hot;
    return LeadTemperature.newLead;
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
