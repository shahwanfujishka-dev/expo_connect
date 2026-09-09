import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/lead_repository.dart';
import '../../exhibitor_appbar/controller/event_dropdown_controller.dart';

class QrScanController extends GetxController {
  final LeadRepository _leadRepository = LeadRepository();
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

    // Get expo_id from dropdown controller
    int? expoId;
    if (Get.isRegistered<EventDropdownController>()) {
      expoId = Get.find<EventDropdownController>().selectedEvent.value?.id;
    }

    if (expoId == null) {
      isProcessing.value = false;
      errorText.value = "Please select an event first";
      Get.snackbar("Error", errorText.value!);
      return;
    }

    final result = await _leadRepository.scanQrCode(expoId: expoId, qrCode: rawValue);

    isProcessing.value = false;

    if (result.success && result.data != null) {
      final data = result.data!;
      
      // Extract user data from the response structure: { "0": { "user": { ... } } }
      // The key '0' could be a string or integer depending on how it was parsed
      final dynamic entry = data['0'] ?? data[0];
      final userData = (entry is Map) ? entry['user'] as Map<String, dynamic>? : null;

      if (userData != null) {
        Get.toNamed(
          Routes.MANUAL_ENTRY,
          arguments: {
            'name': userData['name'],
            'email': userData['email'],
            'phone': userData['phone'],
            'whatsapp': userData['whatsapp'],
            'designation': userData['designation'],
            'company_name': userData['company_name'], 
            'address': userData['address'],
            'website': userData['website'],
            'source': 'qr',
          },
        );
      } else {
        // Fallback to Lead Saved if user data is missing but success is true
        Get.toNamed(
          Routes.LEAD_SAVED,
          arguments: {
            'name': data['data']?['name'] ?? 'Visitor',
            'assignedTo': 'You',
          },
        );
      }
    } else {
      errorText.value = result.error?.message ?? "Failed to capture lead";
      Get.snackbar("Error", errorText.value!);
    }
  }

  void simulateScanTapped() {
    if (!kDebugMode) return;
    onCodeDetected(BarcodeCapture(barcodes: [Barcode(rawValue: 'b118f4f1-c9e4-4475-a7d0-e5e2fdcc3640')]));
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
