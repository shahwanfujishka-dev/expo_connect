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

  Future<void> toggleFavorite(ExhibitorModel exhibitor) async {
    try {
      final result = await repository.saveExhibitor(1, int.parse(exhibitor.id));
      if (result.success) {
        final index = exhibitors.indexWhere((e) => e.id == exhibitor.id);
        if (index != -1) {
          final updated = ExhibitorModel(
            id: exhibitor.id,
            name: exhibitor.name,
            category: exhibitor.category,
            hall: exhibitor.hall,
            booth: exhibitor.booth,
            description: exhibitor.description,
            logoUrl: exhibitor.logoUrl,
            brochures: exhibitor.brochures,
            isFavorite: !exhibitor.isFavorite,
          );
          exhibitors[index] = updated;
          
          Get.snackbar(
            "Success", 
            updated.isFavorite 
                ? "${exhibitor.name} added to your plan" 
                : "${exhibitor.name} removed from your plan",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to update status");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
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
