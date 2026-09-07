import 'package:get/get.dart';
import '../controller/exhibitor_details_controller.dart';

class VisitorExhibitorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorExhibitorDetailsController>(
      () => VisitorExhibitorDetailsController(),
    );
  }
}
