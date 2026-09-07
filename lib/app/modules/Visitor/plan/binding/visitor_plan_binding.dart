import 'package:get/get.dart';
import '../controller/visitor_plan_controller.dart';

class VisitorPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorPlanController>(
      () => VisitorPlanController(),
    );
  }
}
