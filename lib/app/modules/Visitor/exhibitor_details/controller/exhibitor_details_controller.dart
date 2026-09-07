import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';

class VisitorExhibitorDetailsController extends GetxController {
  late ExhibitorModel exhibitor;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    exhibitor = Get.arguments as ExhibitorModel;
    isFavorite.value = exhibitor.isFavorite;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // TODO: Update in database/API
  }

  void saveExhibitor() {
    // TODO: Add to plan/contacts
    Get.snackbar("Success", "${exhibitor.name} added to your plan");
  }

  void downloadBrochure() {
    // TODO: Implement download
    Get.snackbar("Downloading", "Brochure download started...");
  }
}
