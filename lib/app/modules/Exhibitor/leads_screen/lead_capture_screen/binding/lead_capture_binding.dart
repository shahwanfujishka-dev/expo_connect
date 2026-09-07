import 'package:expo_connect/app/modules/Exhibitor/leads_screen/lead_capture_screen/controller/lead_capture_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';


class LeadCaptureBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LeadCaptureController>(LeadCaptureController());
  }
}
