import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class VisitorQrController extends GetxController {
  void onScanSuccess(String code) {
    // Logic to handle scanned exhibitor QR
    // For now, mock a success and go to details
    Get.snackbar("Success", "Exhibitor recognized: $code");
    // Get.toNamed(Routes.VISITOR_EXHIBITOR_DETAILS, arguments: mockExhibitor);
  }

  void closeScan() {
    Get.back();
  }
}
