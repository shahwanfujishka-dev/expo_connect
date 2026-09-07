import 'package:get/get.dart';
import '../controller/visitor_main_controller.dart';
import '../../discover/controller/visitor_discover_controller.dart';
import '../../plan/controller/visitor_plan_controller.dart';
import '../../contacts/controller/visitor_contacts_controller.dart';
import '../../profile/controller/visitor_profile_controller.dart';

class VisitorMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorMainController>(() => VisitorMainController());
    Get.lazyPut<VisitorDiscoverController>(() => VisitorDiscoverController());
    Get.lazyPut<VisitorPlanController>(() => VisitorPlanController());
    Get.lazyPut<VisitorContactsController>(() => VisitorContactsController());
    Get.lazyPut<VisitorProfileController>(() => VisitorProfileController());
  }
}
