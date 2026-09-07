import 'package:get/get.dart';
import '../controller/visitor_compare_controller.dart';

class VisitorCompareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorCompareController>(
      () => VisitorCompareController(),
    );
  }
}
