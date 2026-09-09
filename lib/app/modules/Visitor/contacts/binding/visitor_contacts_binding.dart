import 'package:get/get.dart';
import '../../../../data/repositories/visitor_repository.dart';
import '../controller/visitor_contacts_controller.dart';

class VisitorContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorContactsController>(
      () => VisitorContactsController(repository: VisitorRepository()),
    );
  }
}
