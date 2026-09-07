import 'package:get/get.dart';
import '../controller/visitor_follow_up_controller.dart';

class VisitorFollowUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorFollowUpController>(
      () => VisitorFollowUpController(),
    );
  }
}
