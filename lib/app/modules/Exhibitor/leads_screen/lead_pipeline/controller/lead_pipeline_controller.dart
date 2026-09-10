import 'package:get/get.dart';
import '../../../../../data/models/lead.dart';
import '../../../../../data/repositories/lead_repository.dart';
import '../../../exhibitor_appbar/controller/event_dropdown_controller.dart';
import '../../lead_details/controller/lead_details_controller.dart';

class LeadPipelineController extends GetxController {
  final LeadRepository _leadRepository = LeadRepository();
  
  final allLeads = <Lead>[].obs;
  final filteredLeads = <Lead>[].obs;
  final statuses = <LeadStatus>[].obs;
  final selectedStatusId = RxnInt(); // null means 'All'
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    await fetchStatuses();
    await fetchLeads();
    isLoading.value = false;
  }

  Future<void> fetchStatuses() async {
    final result = await _leadRepository.getLeadStatuses();
    if (result.success && result.data?['data'] != null) {
      statuses.assignAll((result.data!['data'] as List).map((s) => LeadStatus.fromJson(s)).toList());
    }
  }

  Future<void> fetchLeads() async {
    int? expoId;
    if (Get.isRegistered<EventDropdownController>()) {
      expoId = Get.find<EventDropdownController>().selectedEvent.value?.id;
    }

    if (expoId == null) return;

    final result = await _leadRepository.getAllLeads(expoId: expoId);
    
    if (result.success) {
      final List<dynamic> leadsJson = result.data?['data'] ?? [];
      final fetchedLeads = leadsJson.map((json) {
        return Lead(
          id: json['id'].toString(),
          name: json['name'] ?? '',
          status_name: json['status_name'] ?? '',
          status_color: json['status_color'],
          status_id: json['status'], // This is the ID from API
          title: json['designation'] ?? '',
          company: json['company_name'] ?? '',
        );
      }).toList();
      
      allLeads.assignAll(fetchedLeads);
      filterByStatus(selectedStatusId.value);
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to fetch leads");
    }
  }

  void filterByStatus(int? statusId) {
    selectedStatusId.value = statusId;
    if (statusId == null) {
      filteredLeads.assignAll(allLeads);
    } else {
      filteredLeads.assignAll(
        allLeads.where((lead) => lead.status_id?.toString() == statusId.toString()).toList(),
      );
    }
  }

  int getStatusCount(int? statusId) {
    if (statusId == null) return allLeads.length;
    return allLeads.where((lead) => lead.status_id?.toString() == statusId.toString()).length;
  }
}
