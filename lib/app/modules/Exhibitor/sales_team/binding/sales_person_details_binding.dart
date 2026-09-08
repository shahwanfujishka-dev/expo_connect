import 'package:get/get.dart';
import '../controller/sales_person_details_controller.dart';

class SalesPersonDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesPersonDetailsController>(
      () => SalesPersonDetailsController(),
    );
  }
}
