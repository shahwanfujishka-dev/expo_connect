import 'package:expo_connect/app/modules/Exhibitor/QrScan/controller/QrScan_controller.dart';
import 'package:get/get.dart';

class QrscanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QrScanController>(QrScanController());
  }
}
