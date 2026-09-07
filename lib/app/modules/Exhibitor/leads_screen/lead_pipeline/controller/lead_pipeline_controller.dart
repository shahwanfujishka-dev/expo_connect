import 'package:get/get.dart';
import '../../../../../data/models/lead.dart';

class LeadPipelineController extends GetxController {
  final allLeads = <Lead>[].obs;
  final filteredLeads = <Lead>[].obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLeads();
  }

  void loadLeads() {
    // Simulated data with phone and email for testing actions
    final mockLeads = [
      const Lead(
        id: '1',
        name: 'Rahul Mehta',
        title: 'Marketing Head',
        company: 'Nova Textiles',
        temperature: LeadTemperature.hot,
        phone: '+919876543210',
        email: 'rahul@novatextiles.com',
      ),
      const Lead(
        id: '2',
        name: 'Sara Khan',
        title: 'Procurement',
        company: 'Delta Corp',
        temperature: LeadTemperature.warm,
        phone: '+919988776655',
        email: 'sara@deltacorp.com',
      ),
      const Lead(
        id: '3',
        name: 'Amit Lal',
        title: 'CEO',
        company: 'Bluestone Inc',
        temperature: LeadTemperature.cold,
        phone: '+919000011111',
        email: 'amit@bluestone.com',
      ),
      const Lead(
        id: '4',
        name: 'Jon Park',
        title: 'Designer',
        company: 'Rivet Labs',
        temperature: LeadTemperature.newLead,
        phone: '+918888877777',
        email: 'jon@rivetlabs.com',
      ),
      const Lead(
        id: '5',
        name: 'Priya Singh',
        title: 'Manager',
        company: 'Tech Solutions',
        temperature: LeadTemperature.hot,
        phone: '+917777766666',
        email: 'priya@techsolutions.com',
      ),
    ];
    allLeads.assignAll(mockLeads);
    applyFilter('All');
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    if (filter == 'All') {
      filteredLeads.assignAll(allLeads);
    } else {
      filteredLeads.assignAll(allLeads.where((lead) => lead.temperature.label == filter).toList());
    }
  }

  int getCount(String label) {
    if (label == 'All') return allLeads.length;
    return allLeads.where((lead) => lead.temperature.label == label).length;
  }
}
