import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/brochure_model.dart';
import '../../../../data/repositories/brochure_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/services/endpoints.dart';

class BrochureController extends GetxController {
  final BrochureRepository repository;
  BrochureController({required this.repository});

  final brochures = <Brochure>[].obs;
  final isLoading = false.obs;
  final isAdding = false.obs;
  final deletingId = RxnInt(); // Track which brochure is being deleted

  // Form fields for Add Brochure Screen
  final titleController = TextEditingController();
  final selectedFile = Rx<File?>(null);
  final fileType = 'image'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBrochures();
  }

  Future<void> fetchBrochures() async {
    isLoading.value = true;
    final result = await repository.getBrochures();
    isLoading.value = false;

    if (result.success) {
      brochures.assignAll(result.data ?? []);
    } else {
      Get.snackbar('Error', result.error?.message ?? 'Failed to fetch brochures');
    }
  }

  void goToAddBrochure() {
    titleController.clear();
    selectedFile.value = null;
    fileType.value = 'image';
    Get.toNamed(Routes.ADD_BROCHURE);
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        selectedFile.value = File(path);
        
        if (path.toLowerCase().endsWith('.pdf')) {
          fileType.value = 'pdf';
        } else {
          fileType.value = 'image';
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file. If you just added the plugin, please rebuild the app.');
      debugPrint('File picking error: $e');
    }
  }

  Future<void> viewBrochure(Brochure brochure) async {
    if (brochure.filePath == null) return;
    
    final url = '${Endpoints.baseUrl}/public/storage/${brochure.filePath}';
    final uri = Uri.parse(url);
    
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not open the brochure');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error opening brochure: $e');
    }
  }

  Future<void> uploadBrochure() async {
    if (titleController.text.isEmpty || selectedFile.value == null) {
      Get.snackbar('Error', 'Please provide title and file');
      return;
    }

    isAdding.value = true;
    final result = await repository.addBrochure(
      title: titleController.text,
      filePath: selectedFile.value!.path,
      fileType: fileType.value,
    );
    isAdding.value = false;

    if (result.success) {
      Get.back();
      Get.snackbar('Success', 'Brochure uploaded successfully');
      fetchBrochures();
    } else {
      Get.snackbar('Error', result.error?.message ?? 'Failed to upload brochure');
    }
  }

  Future<void> deleteBrochure(int id) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Brochure',style: TextStyle(color: Colors.black),),
        content: const Text('Are you sure you want to delete this brochure?',style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel',style: TextStyle(color: Colors.black))),
          TextButton(
            onPressed: () async {
              Get.back();
              deletingId.value = id;
              final result = await repository.deleteBrochure(id);
              if (result.success) {
                brochures.removeWhere((b) => b.id == id);
                Get.snackbar('Success', 'Brochure deleted successfully');
              } else {
                Get.snackbar('Error', result.error?.message ?? 'Failed to delete brochure');
              }
              deletingId.value = null;
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }
}
