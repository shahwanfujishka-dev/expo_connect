import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';

class VisitorContactsController extends GetxController {
  final selectedTab = 0.obs; // 0: All, 1: Recent

  final contacts = <ExhibitorModel>[
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

  void setTab(int index) => selectedTab.value = index;
}
