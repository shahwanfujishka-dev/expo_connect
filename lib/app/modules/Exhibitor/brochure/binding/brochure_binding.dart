import 'package:get/get.dart';
import '../controller/brochure_controller.dart';
import '../../../../data/repositories/brochure_repository.dart';

class BrochureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrochureRepository>(() => BrochureRepository());
    Get.lazyPut<BrochureController>(
      () => BrochureController(repository: Get.find<BrochureRepository>()),
    );
  }
}
