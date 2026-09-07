import 'package:expo_connect/app/modules/Exhibitor/exhibitor_profile/controller/exhibitor_profile_controller.dart';
import 'package:get/get.dart';

class ExhibitorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExhibitorProfileController>(ExhibitorProfileController());
  }
}
