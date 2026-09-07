import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';

class VisitorCompareController extends GetxController {
  final exhibitorsToCompare = <ExhibitorModel>[
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
  ].obs;

  // Mock comparison data
  final comparisonMetrics = [
    "Category",
    "Booth",
    "Lead Quality",
    "MOQ",
  ];

  String getMetricValue(ExhibitorModel exhibitor, String metric) {
    switch (metric) {
      case "Category":
        return exhibitor.category;
      case "Booth":
        return "${exhibitor.hall}, ${exhibitor.booth}";
      case "Lead Quality":
        return exhibitor.id == "1" ? "High" : "Medium";
      case "MOQ":
        return exhibitor.id == "1" ? "500 units" : "200 units";
      default:
        return "-";
    }
  }
}
