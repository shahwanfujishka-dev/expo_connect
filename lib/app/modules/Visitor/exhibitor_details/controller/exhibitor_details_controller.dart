import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../data/repositories/visitor_repository.dart';
import '../../../../data/services/endpoints.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorExhibitorDetailsController extends GetxController {
  final VisitorRepository repository;
  VisitorExhibitorDetailsController({required this.repository});

  late ExhibitorModel initialExhibitor;
  final companyDetails = <String, dynamic>{}.obs;
  final isLoading = false.obs;
  final isFavorite = false.obs;
  final isBrochuresExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    initialExhibitor = Get.arguments as ExhibitorModel;
    isFavorite.value = initialExhibitor.isFavorite;
    fetchExhibitorDetails();
  }

  Future<void> fetchExhibitorDetails() async {
    isLoading.value = true;
    try {
      final result = await repository.getExhibitorDetails(1, int.parse(initialExhibitor.id));
      if (result.success && result.data != null) {
        final company = result.data!['company'] ?? {};
        companyDetails.value = company;
        isFavorite.value = company['is_saved'] ?? false;
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to load details");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String get logoUrl {
    final logoPath = companyDetails['logo'];
    if (logoPath != null && logoPath.isNotEmpty) {
      return "${Endpoints.storageUrl}$logoPath";
    }
    return "";
  }

  Future<void> toggleFavorite() async {
    await saveExhibitor();
  }

  Future<void> saveExhibitor() async {
    try {
      final result = await repository.saveExhibitor(1, int.parse(initialExhibitor.id));
      if (result.success) {
        isFavorite.value = !isFavorite.value;
        Get.snackbar(
          "Success",
          isFavorite.value
              ? "${initialExhibitor.name} added to your plan"
              : "${initialExhibitor.name} removed from your plan"
        );
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to update status");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void toggleBrochures() {
    isBrochuresExpanded.value = !isBrochuresExpanded.value;
  }

  Future<void> openBrochure(String filePath) async {
    if (filePath.isEmpty) return;
    final url = Uri.parse("${Endpoints.storageUrl}$filePath");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open brochure");
    }
  }

  Future<void> saveBrochure(int brochureId) async {
    try {
      final result = await repository.saveBrochure(brochureId);
      if (result.success) {
        Get.snackbar("Success", "Brochure saved successfully");
        fetchExhibitorDetails(); // Refresh to update saved state if available
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to save brochure");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> deleteBrochure(int brochureId) async {
    try {
      final result = await repository.deleteBrochure(brochureId);
      if (result.success) {
        Get.snackbar("Success", "Brochure removed from saved");
        fetchExhibitorDetails(); // Refresh to update saved state
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to remove brochure");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
