import 'package:get/get.dart';
import '../controller/visitor_complete_profile_controller.dart';

class VisitorCompleteProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorCompleteProfileController>(
      () => VisitorCompleteProfileController(),
    );
  }
}
