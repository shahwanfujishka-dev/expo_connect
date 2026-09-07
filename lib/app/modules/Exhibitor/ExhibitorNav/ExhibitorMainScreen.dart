import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../dashboard/Dashboard_Screen.dart';
import '../exhibitor_profile/my_profile_screen.dart';
import '../leads_screen/lead_pipeline/lead_pipeline_screen.dart';
import 'ExhibitorBottomNav.dart';
import 'ExhibitorNavController.dart';
import '../exhibitor_drawer/ExhibitorDrawer.dart';

class ExhibitorMainScreen extends GetView<ExhibitorNavController> {
  const ExhibitorMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            body: IndexedStack(
              index: controller.currentIndex.value,
              children: [
                const DashboardScreen(),
                const LeadPipelineScreen(),
                const SizedBox.shrink(), // Placeholder for Scan
                Center(
                  child: Text(
                    'Events (Coming Soon)',
                    style: AppTextStyles.body,
                  ),
                ),
                const MyProfileScreen(),
              ],
            ),
            bottomNavigationBar: ExhibitorBottomNav(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changePage,
            ),
          ),
          ExhibitorDrawer(
            isOpen: controller.isDrawerOpen.value,
            onClose: controller.closeDrawer,
            onLogout: controller.logout,
          ),
        ],
      ),
    );
  }
}
