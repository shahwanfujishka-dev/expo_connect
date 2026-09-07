import 'package:get/get.dart';
import '../controller/visitor_qr_controller.dart';

class VisitorQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorQrController>(
      () => VisitorQrController(),
    );
  }
}
