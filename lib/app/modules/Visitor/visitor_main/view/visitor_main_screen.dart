import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            const VisitorDiscoverScreen(),
            const VisitorPlanScreen(),
            const SizedBox.shrink(), // Placeholder for Scan
            const VisitorContactsScreen(),
            const VisitorProfileScreen(),
          ],
        ),
        bottomNavigationBar: VisitorBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
