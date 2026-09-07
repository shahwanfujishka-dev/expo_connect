import 'package:get/get.dart';
import '../controller/role_controller.dart';

class RoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleController>(
      () => RoleController(),
    );
  }
}
