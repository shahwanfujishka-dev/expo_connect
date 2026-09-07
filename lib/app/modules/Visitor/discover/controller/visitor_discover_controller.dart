import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';

class VisitorDiscoverController extends GetxController {
  final searchQuery = "".obs;
  final selectedCategory = "All".obs;

  final categories = ["All", "Textiles", "Tech", "Logistics"];

  final exhibitors = <ExhibitorModel>[
    ExhibitorModel(
      id: "1",
      name: "Nova Textiles",
      category: "Textiles",
      hall: "Hall 2",
      booth: "Booth A52",
    ),
    ExhibitorModel(
      id: "2",
      name: "Orbit Retail",
      category: "Tech",
      hall: "Hall 1",
      booth: "Booth C21",
    ),
    ExhibitorModel(
      id: "3",
      name: "Bluewave Inc",
      category: "Logistics",
      hall: "Hall 3",
      booth: "Booth B10",
    ),
    ExhibitorModel(
      id: "4",
      name: "Circuit Co",
      category: "Tech",
      hall: "Hall 1",
      booth: "Booth D05",
    ),
  ].obs;

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
