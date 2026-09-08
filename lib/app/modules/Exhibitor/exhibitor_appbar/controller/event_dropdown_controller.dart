import 'package:get/get.dart';
import '../../../../data/models/event_dropdown_model.dart';
import '../../../../data/providers/api_service.dart';
import '../../../../data/services/endpoints.dart';
import '../../dashboard/controller/dashBoard_controller.dart';
import '../../leads_screen/lead_pipeline/controller/lead_pipeline_controller.dart';

class EventDropdownController extends GetxController {
  final ApiService _apiService = ApiService.instance;

  final RxList<EventModel> events = <EventModel>[].obs;
  final Rxn<EventModel> selectedEvent = Rxn<EventModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    isLoading.value = true;
    final result = await _apiService.get<EventDropdownResponse>(
      Endpoints.eventsDropdown,
      parser: (json) => EventDropdownResponse.fromJson(json),
    );

    if (result.success && result.data != null) {
      events.assignAll(result.data!.data.data);
      if (events.isNotEmpty) {
        // Use setSelectedEvent to trigger data refresh in other controllers
        setSelectedEvent(events.first);
      }
    }
    isLoading.value = false;
  }

  void setSelectedEvent(EventModel? event) {
    if (selectedEvent.value?.id == event?.id && events.isNotEmpty) {
      // If same event, but we might want to force refresh if it was triggered by fetchEvents
      // but usually selectedEvent.value is null initially.
    }
    
    selectedEvent.value = event;
    
    if (event == null) return;

    // Refresh Dashboard if it's currently in memory
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboard();
    }
    
    // Refresh Lead Pipeline if it's currently in memory
    if (Get.isRegistered<LeadPipelineController>()) {
      Get.find<LeadPipelineController>().fetchLeads();
    }
  }
}
