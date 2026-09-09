import 'package:get/get.dart';
import '../../../../data/repositories/visitor_repository.dart';
import '../controller/exhibitor_details_controller.dart';

class VisitorExhibitorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorRepository>(() => VisitorRepository());
    Get.lazyPut<VisitorExhibitorDetailsController>(
      () => VisitorExhibitorDetailsController(repository: Get.find<VisitorRepository>()),
    );
  }
}
