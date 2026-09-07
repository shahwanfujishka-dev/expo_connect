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
        nameController.text = lines[0];
        if (lines.length > 1) companyController.text = lines[1];
        final phoneRegex = RegExp(r'(\+?\d[\d\-\s]{8,})');
        final match = phoneRegex.firstMatch(fullText);
        if (match != null) {
          phoneController.text = match.group(0) ?? "";
        }
      }
      state.value = CardScanState.done;
    } catch (e) {
      state.value = CardScanState.failed;
      errorText.value = "Failed to read card: $e";
    }
  }

  Future<void> confirmDetailsTapped() async {
    if (isSaving.value) return;
    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSaving.value = false;
    Get.toNamed(
      Routes.LEAD_SAVED,
      arguments: {
        'name': nameController.text.trim(),
        'assignedTo': 'You',
      },
    );
  }

  void retakeTapped() {
    state.value = CardScanState.idle;
    nameController.clear();
    companyController.clear();
    phoneController.clear();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    textRecognizer.close();
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}