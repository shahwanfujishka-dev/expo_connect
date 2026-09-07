import 'package:get/get.dart';

class BrochureModel {
  final String title;
  final String size;
  final String type;

  BrochureModel({required this.title, required this.size, required this.type});
}

class VisitorBrochuresController extends GetxController {
  final brochures = <BrochureModel>[
    BrochureModel(title: "Nova Textiles — Catalogue.pdf", size: "2.4 MB", type: "pdf"),
    BrochureModel(title: "Orbit Retail — Product sheet.jpg", size: "1.2 MB", type: "image"),
    BrochureModel(title: "Bluewave — Company deck.pptx", size: "5.8 MB", type: "ppt"),
    BrochureModel(title: "Circuit Co — Demo reel.mp4", size: "12.4 MB", type: "video"),
  ].obs;

  void downloadBrochure(BrochureModel brochure) {
    Get.snackbar("Downloading", "Downloading ${brochure.title}...");
  }
}
