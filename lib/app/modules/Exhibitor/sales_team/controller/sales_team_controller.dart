import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/sales_team_model.dart';
import '../../../../data/repositories/sales_team_repository.dart';

class SalesTeamController extends GetxController {
  final SalesTeamRepository _repository = SalesTeamRepository();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingPerformance = false.obs;
  final RxBool isCreating = false.obs;
  final RxList<SalesPerson> salesTeam = <SalesPerson>[].obs;
  final Rxn<TeamPerformanceResponse> performanceData = Rxn<TeamPerformanceResponse>();
  final RxString errorMessage = ''.obs;

  // Controllers for creation form
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxString selectedRole = 'salesperson'.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    await Future.wait([
      fetchSalesTeam(),
      fetchPerformance(),
    ]);
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

  Future<void> fetchPerformance() async {
    isLoadingPerformance.value = true;
    final result = await _repository.getTeamPerformance();
    isLoadingPerformance.value = false;

    if (result.success && result.data != null) {
      performanceData.value = result.data;
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
      refreshData();
    } else {
      Get.snackbar('Error', result.error?.message ?? 'Failed to create member');
    }
  }

  Future<SalesPerson?> getMemberDetails(int id) async {
    final result = await _repository.getSalesPersonDetails(id);
    if (result.success) {
      return result.data;
    }
    return null;
  }
}
