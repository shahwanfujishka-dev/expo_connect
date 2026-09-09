import 'package:get/get.dart';
import '../../../../data/repositories/visitor_repository.dart';
import '../../../Exhibitor/exhibitor_profile/controller/my_profile_controller.dart';
import '../controller/visitor_main_controller.dart';
import '../../discover/controller/visitor_discover_controller.dart';
import '../../plan/controller/visitor_plan_controller.dart';
import '../../contacts/controller/visitor_contacts_controller.dart';
import '../../profile/controller/visitor_profile_controller.dart';

class VisitorMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorRepository>(() => VisitorRepository());
    Get.lazyPut<VisitorMainController>(() => VisitorMainController());
    Get.lazyPut<VisitorDiscoverController>(
      () => VisitorDiscoverController(repository: Get.find<VisitorRepository>()),
    );
    Get.lazyPut<VisitorPlanController>(() => VisitorPlanController());
    Get.lazyPut<VisitorContactsController>(
      () => VisitorContactsController(repository: Get.find<VisitorRepository>()),
    );
    Get.lazyPut<MyProfileController>(() => MyProfileController());
    Get.lazyPut<VisitorProfileController>(() => VisitorProfileController());
  }
}
