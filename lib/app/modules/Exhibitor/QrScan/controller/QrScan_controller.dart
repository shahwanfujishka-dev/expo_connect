import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../routes/app_routes.dart';

class QrScanController extends GetxController {
  final isProcessing = false.obs;
  final errorText = RxnString();

  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  Future<void> onCodeDetected(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final String? rawValue = barcodes.first.rawValue;
    if (rawValue == null || isProcessing.value) return;

    isProcessing.value = true;
    errorText.value = null;

    // Simulate verification
    await Future.delayed(const Duration(milliseconds: 800));
    isProcessing.value = false;

    Get.toNamed(
      Routes.LEAD_SAVED,
      arguments: {
        'name': 'Rahul Mehta',
        'assignedTo': 'You',
      },
    );
  }

  void simulateScanTapped() {
    if (!kDebugMode) return;
    Get.toNamed(
      Routes.LEAD_SAVED,
      arguments: {
        'name': 'Rahul Mehta (Simulated)',
        'assignedTo': 'You',
      },
    );
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
