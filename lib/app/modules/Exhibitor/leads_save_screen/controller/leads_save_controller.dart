import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class LeadSavedController extends GetxController {
  final String leadName = Get.arguments?['name'] ?? '';
  final String assignedTo = Get.arguments?['assignedTo'] ?? 'You';

  final notesController = TextEditingController();
  final isSavingNotes = false.obs;

  Future<void> addNotesTapped() async {
    final notes = notesController.text.trim();
    if (notes.isEmpty) {
      doneTapped();
      return;
    }

    isSavingNotes.value = true;
    // TODO: replace with a real call, e.g.
    // await ApiService.instance.post('/exhibitor/leads/notes',
    //   authMode: AuthMode.header, body: {'notes': notes});
    await Future.delayed(const Duration(milliseconds: 400));
    isSavingNotes.value = false;

    doneTapped();
  }

  void doneTapped() => Get.offAllNamed(Routes.DASHBOARD);

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}