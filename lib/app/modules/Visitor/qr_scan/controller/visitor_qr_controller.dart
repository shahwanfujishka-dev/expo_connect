import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../data/repositories/visitor_repository.dart';
import '../../../../routes/app_routes.dart';

class VisitorQrController extends GetxController {
  final VisitorRepository repository;
  VisitorQrController({required this.repository});

  final isLoading = false.obs;

  Future<void> onScanSuccess(String code) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final result = await repository.scanQrCode(code);
      if (result.success && result.data != null) {
        // The API returns the user object in 'user' key based on the response structure
        final data = result.data!['user'] ?? result.data!['data'] ?? {};
        
        final exhibitor = ExhibitorModel(
          id: data['id'].toString(),
          name: data['name'] ?? data['company_name'] ?? '',
          category: data['category'] ?? 'All',
          hall: data['hall'] ?? '',
          booth: data['stall'] ?? data['booth'] ?? '',
          isFavorite: data['is_saved'] ?? false,
          logoUrl: data['logo'],
        );
        
        Get.snackbar("Success", result.data!['message'] ?? "Exhibitor recognized: ${exhibitor.name}");
        Get.offNamed(Routes.VISITOR_EXHIBITOR_DETAILS, arguments: exhibitor);
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to recognize QR code");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void closeScan() {
    Get.back();
  }
}
