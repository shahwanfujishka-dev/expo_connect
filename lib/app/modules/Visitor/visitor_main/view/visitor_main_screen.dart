import 'package:expo_connect/app/modules/Exhibitor/exhibitor_profile/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../visitor_drawer/VisitorDrawer.dart';
import '../controller/visitor_main_controller.dart';
import '../widgets/visitor_bottom_nav.dart';
import '../../discover/view/visitor_discover_screen.dart';
import '../../plan/view/visitor_plan_screen.dart';
import '../../contacts/view/visitor_contacts_screen.dart';
import '../../profile/view/visitor_profile_screen.dart';

class VisitorMainScreen extends GetView<VisitorMainController> {
  const VisitorMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await controller.handleBackPress();
        },
        child: Stack(
          children: [
            Scaffold(
              body: IndexedStack(
                index: controller.currentIndex.value,
                children: const [
                  VisitorDiscoverScreen(),
                  VisitorPlanScreen(),
                  SizedBox.shrink(), // Placeholder for Scan
                  VisitorContactsScreen(),
                  MyProfileScreen(),
                ],
              ),
              bottomNavigationBar: VisitorBottomNav(
                currentIndex: controller.currentIndex.value,
                onTap: controller.changePage,
              ),
            ),
            VisitorDrawer(
              isOpen: controller.isDrawerOpen.value,
              onClose: controller.closeDrawer,
              onLogout: controller.logout,
            ),
          ],
        ),
      ),
    );
  }
}
