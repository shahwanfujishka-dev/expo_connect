import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../data/repositories/visitor_repository.dart';

class VisitorDiscoverController extends GetxController {
  final VisitorRepository repository;
  VisitorDiscoverController({required this.repository});

  final searchQuery = "".obs;
  final selectedCategory = "All".obs;
  final isLoading = false.obs;

  final categories = ["All", "Textiles", "Tech", "Logistics"];
  final exhibitors = <ExhibitorModel>[].obs;
  final stats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    isLoading.value = true;
    try {
      final result = await repository.getVisitorDashboard(1);
      if (result.success && result.data != null) {
        final responseData = result.data!['data'] ?? {};
        final List companiesData = responseData['companies'] ?? responseData['exhibitors'] ?? [];
        
        exhibitors.value = companiesData.map((e) => ExhibitorModel(
          id: e['id'].toString(),
          name: e['name'] ?? e['company_name'] ?? '',
          category: e['category'] ?? 'All',
          hall: e['hall'] ?? '',
          booth: e['stall'] ?? '',
          isFavorite: e['is_saved'] ?? false,
        )).toList();
        
        stats.value = responseData['stats'] ?? {};
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to load dashboard");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<ExhibitorModel> get filteredExhibitors {
    return exhibitors.where((exhibitor) {
      final matchesSearch = exhibitor.name
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      final matchesCategory = selectedCategory.value == "All" ||
          exhibitor.category == selectedCategory.value;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void onSearch(String query) {
    searchQuery.value = query;
  }
}
