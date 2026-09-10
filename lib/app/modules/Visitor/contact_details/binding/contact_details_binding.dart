import 'package:get/get.dart';
import '../../../../data/repositories/visitor_repository.dart';
import '../controller/contact_details_controller.dart';

class VisitorContactDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorContactDetailsController>(
      () => VisitorContactDetailsController(repository: VisitorRepository()),
    );
  }
}
