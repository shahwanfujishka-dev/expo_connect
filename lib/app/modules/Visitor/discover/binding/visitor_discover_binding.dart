import 'package:get/get.dart';
import '../controller/visitor_discover_controller.dart';

class VisitorDiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<VisitorDiscoverController>(VisitorDiscoverController(),
    );
  }
}
