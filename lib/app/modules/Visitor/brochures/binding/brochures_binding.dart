import 'package:get/get.dart';
import '../controller/visitor_brochures_controller.dart';

class VisitorBrochuresBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorBrochuresController>(
      () => VisitorBrochuresController(),
    );
  }
}
