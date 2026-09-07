import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class LeadCaptureController extends GetxController {
  void scanQrTapped() => Get.toNamed(Routes.QR_SCAN);
  void scanCardTapped() => Get.toNamed(Routes.BUSINESS_CARD_SCAN);
  void manualEntryTapped() => Get.toNamed(Routes.MANUAL_ENTRY);
}