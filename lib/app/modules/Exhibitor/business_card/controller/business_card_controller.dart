import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../../routes/app_routes.dart';

enum CardScanState { idle, reading, done, failed }

class BusinessCardScanController extends GetxController {
  final state = CardScanState.idle.obs;
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final isSaving = false.obs;
  final errorText = RxnString();
  CameraController? cameraController;
  final isCameraInitialized = false.obs;
  final textRecognizer = TextRecognizer();

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      errorText.value = "Failed to initialize camera";
    }
  }

  bool get hasResult => state.value == CardScanState.done;

  Future<void> captureAndReadTapped() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;
    state.value = CardScanState.reading;
    errorText.value = null;
    try {
      final XFile image = await cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String fullText = recognizedText.text;
      List<String> lines = fullText.split('\n');

      if (lines.isNotEmpty) {
        // Simple heuristic: First line is usually the name
        nameController.text = lines[0].trim();

        // Try to find company name (often 2nd line)
        if (lines.length > 1) {
          companyController.text = lines[1].trim();
        }

        // Extract Phone
        final phoneRegex = RegExp(r'(\+?\d[\d\-\s]{8,})');
        final phoneMatch = phoneRegex.firstMatch(fullText);
        if (phoneMatch != null) {
          phoneController.text = phoneMatch.group(0)?.trim() ?? "";
        }

        // Extract Email
        final emailRegex = RegExp(r"([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)");
        final emailMatch = emailRegex.firstMatch(fullText);
        if (emailMatch != null) {
          emailController.text = emailMatch.group(0)?.trim() ?? "";
        }
      }
      state.value = CardScanState.done;
    } catch (e) {
      state.value = CardScanState.failed;
      errorText.value = "Failed to read card: $e";
    }
  }

  Future<void> confirmDetailsTapped() async {
    // Navigate to Manual Entry with extracted data
    Get.toNamed(
      Routes.MANUAL_ENTRY,
      arguments: {
        'name': nameController.text.trim(),
        'company_name': companyController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'source': 'card_scan',
      },
    );
  }

  void retakeTapped() {
    state.value = CardScanState.idle;
    nameController.clear();
    companyController.clear();
    phoneController.clear();
    emailController.clear();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    textRecognizer.close();
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
