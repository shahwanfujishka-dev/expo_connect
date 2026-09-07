import 'package:get/get.dart';
import '../controller/lead_pipeline_controller.dart';

class LeadPipelineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadPipelineController>(() => LeadPipelineController());
  }
}
