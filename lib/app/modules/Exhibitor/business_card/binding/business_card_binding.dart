import 'package:expo_connect/app/modules/Exhibitor/business_card/controller/business_card_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class BusinessCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BusinessCardScanController>(BusinessCardScanController());
  }
}
