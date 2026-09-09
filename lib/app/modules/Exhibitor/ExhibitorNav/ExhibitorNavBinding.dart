import 'package:get/get.dart';
import '../dashboard/controller/dashBoard_controller.dart';
import '../events/controller/events_controller.dart';
import '../exhibitor_profile/controller/exhibitor_profile_controller.dart';
import '../exhibitor_profile/controller/my_profile_controller.dart';
import '../leads_screen/lead_pipeline/controller/lead_pipeline_controller.dart';
import 'ExhibitorNavController.dart';

class ExhibitorNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExhibitorNavController>(ExhibitorNavController());
    Get.put<DashboardController>(DashboardController());
    Get.put<LeadPipelineController>(LeadPipelineController());
    Get.put<EventsController>(EventsController());
    Get.lazyPut<MyProfileController>(() => MyProfileController());
    Get.lazyPut<ExhibitorProfileController>(() => ExhibitorProfileController());
  }
}
