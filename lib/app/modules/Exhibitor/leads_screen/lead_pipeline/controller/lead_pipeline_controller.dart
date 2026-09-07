import 'package:get/get.dart';
import '../../../../../data/models/lead.dart';
import '../../../../../data/repositories/lead_repository.dart';

class LeadPipelineController extends GetxController {
  final LeadRepository _leadRepository = LeadRepository();
  
  final allLeads = <Lead>[].obs;
  final filteredLeads = <Lead>[].obs;
  final selectedFilter = 'All'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    isLoading.value = true;
    final result = await _leadRepository.getAllLeads();
    
    if (result.success) {
      final List<dynamic> leadsJson = result.data?['data'] ?? [];
      final fetchedLeads = leadsJson.map((json) {
        return Lead(
          id: json['id'].toString(),
          name: json['name'] ?? '',
          title: json['designation'] ?? '',
          company: json['company_name'] ?? '',
          temperature: _mapStatusToTemperature(json['status']),
        );
      }).toList();
      
      allLeads.assignAll(fetchedLeads);
      applyFilter(selectedFilter.value);
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to fetch leads");
    }
    
    isLoading.value = false;
  }

  LeadTemperature _mapStatusToTemperature(dynamic status) {
    // Mapping status from API to LeadTemperature
    if (status == 1) return LeadTemperature.hot;
    // Add more mapping logic if needed
    return LeadTemperature.newLead;
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    if (filter == 'All') {
      filteredLeads.assignAll(allLeads);
    } else {
      filteredLeads.assignAll(
        allLeads.where((lead) => lead.temperature.label == filter).toList(),
      );
    }
  }

  int getCount(String label) {
    if (label == 'All') return allLeads.length;
    return allLeads.where((lead) => lead.temperature.label == label).length;
  }
}
