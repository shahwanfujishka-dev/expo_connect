import 'package:get/get.dart';
import '../../../../data/repositories/visitor_repository.dart';
import '../controller/visitor_discover_controller.dart';

class VisitorDiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorRepository>(() => VisitorRepository());
    Get.put<VisitorDiscoverController>(VisitorDiscoverController(
      repository: Get.find<VisitorRepository>(),
    ));
  }
}
