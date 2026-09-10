import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../data/repositories/visitor_repository.dart';

class VisitorContactDetailsController extends GetxController {
  final VisitorRepository repository;
  VisitorContactDetailsController({required this.repository});

  late ExhibitorModel exhibitor;
  final isLoading = false.obs;
  final isUpdating = false.obs;
  
  final currentStatus = "".obs;
  final notesController = TextEditingController();
  final isFavorite = false.obs;

  final List<String> statuses = ['planned', 'visited', 'interested', 'followup'];

  @override
  void onInit() {
    super.onInit();
    exhibitor = Get.arguments as ExhibitorModel;
    currentStatus.value = exhibitor.planStatus ?? "";
    notesController.text = exhibitor.notes ?? "";
    isFavorite.value = exhibitor.isFavorite;
  }

  Future<void> updateStatus(String status) async {
    if (exhibitor.contactId == null) return;
    
    try {
      isUpdating.value = true;
      final result = await repository.updateContactStatus(exhibitor.contactId!, status);
      if (result.success) {
        currentStatus.value = status;
        Get.snackbar("Success", "Status updated to ${status.capitalizeFirst}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update status");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> saveNotes() async {
    if (exhibitor.contactId == null) return;

    try {
      isUpdating.value = true;
      final result = await repository.updateContactNotes(exhibitor.contactId!, notesController.text);
      if (result.success) {
        Get.snackbar("Success", "Notes updated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update notes");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    if (exhibitor.contactId == null) return;

    try {
      final newFav = !isFavorite.value;
      final result = await repository.updateContactFavorite(exhibitor.contactId!, newFav ? 1 : 0);
      if (result.success) {
        isFavorite.value = newFav;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update favorite");
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
