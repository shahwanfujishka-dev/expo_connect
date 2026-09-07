import 'package:expo_connect/app/modules/Exhibitor/manual_entry/controller/manual_controller.dart';
import 'package:get/get.dart';

class ManualEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ManualEntryController>(ManualEntryController());
  }
}
