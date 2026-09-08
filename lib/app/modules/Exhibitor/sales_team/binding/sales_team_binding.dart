import 'package:get/get.dart';
import '../controller/sales_team_controller.dart';

class SalesTeamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesTeamController>(
      () => SalesTeamController(),
    );
  }
}
