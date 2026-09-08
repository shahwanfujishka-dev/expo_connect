import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/sales_team_model.dart';
import '../../../../data/repositories/sales_team_repository.dart';

class SalesTeamController extends GetxController {
  final SalesTeamRepository _repository = SalesTeamRepository();

  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxList<SalesPerson> salesTeam = <SalesPerson>[].obs;
  final RxString errorMessage = ''.obs;

  // Controllers for creation form
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxString selectedRole = 'salesperson'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSalesTeam();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> fetchSalesTeam() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await _repository.getSalesTeam();
    
    isLoading.value = false;
    
    if (result.success && result.data != null) {
      salesTeam.assignAll(result.data!.data);
    } else {
      errorMessage.value = result.error?.message ?? 'Failed to load sales team';
    }
  }

  Future<void> createMember() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isCreating.value = true;
    final result = await _repository.createSalesTeamMember(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      role: selectedRole.value,
    );
    isCreating.value = false;

    if (result.success) {
      Get.back(); // Close dialog/bottom sheet
      Get.snackbar('Success', result.data['message'] ?? 'Member invited successfully');
      nameController.clear();
      emailController.clear();
      fetchSalesTeam(); // Refresh the list
    } else {
      Get.snackbar('Error', result.error?.message ?? 'Failed to create member');
    }
  }
}
