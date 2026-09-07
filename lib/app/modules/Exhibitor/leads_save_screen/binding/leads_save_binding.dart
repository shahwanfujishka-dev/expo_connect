import 'package:expo_connect/app/modules/Exhibitor/leads_save_screen/controller/leads_save_controller.dart';
import 'package:get/get.dart';

class LeadsSaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LeadSavedController>(LeadSavedController());
  }
}
