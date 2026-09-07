import 'package:get/get.dart';
import '../controller/visitor_profile_controller.dart';

class VisitorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorProfileController>(
      () => VisitorProfileController(),
    );
  }
}
