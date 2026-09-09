import 'package:get/get.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../data/repositories/visitor_repository.dart';

class VisitorContactsController extends GetxController {
  final VisitorRepository repository;
  VisitorContactsController({required this.repository});

  final selectedTab = 0.obs; // 0: All, 1: Favorites
  final isLoading = false.obs;
  final contacts = <ExhibitorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    isLoading.value = true;
    try {
      // Using expo_id: 1 as per requirements or from a service
      final result = await repository.getContactBook(1, isFavorite: selectedTab.value == 1 ? 1 : 0);
      if (result.success && result.data != null) {
        final List data = result.data!['data'] ?? [];
        contacts.value = data.map((e) => ExhibitorModel(
          id: e['company_id']?.toString() ?? '',
          contactId: e['id'],
          name: e['name'] ?? '',
          category: e['category'] ?? '',
          hall: e['hall_name'] ?? '',
          booth: e['stall_no'] ?? '',
          isFavorite: (e['is_favorite'] == 1 || e['is_favorite'] == true),
          logoUrl: e['logo'],
          planStatus: e['plan_status'],
          notes: e['notes'],
        )).toList();
      } else {
        Get.snackbar("Error", result.error?.message ?? "Failed to load contacts");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(ExhibitorModel exhibitor) async {
    if (exhibitor.contactId == null) return;
    
    final newStatus = exhibitor.isFavorite ? 0 : 1;
    final result = await repository.updateContactFavorite(exhibitor.contactId!, newStatus);
    
    if (result.success) {
      fetchContacts();
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to update favorite");
    }
  }

  Future<void> updateStatus(int contactId, String status) async {
    final result = await repository.updateContactStatus(contactId, status);
    if (result.success) {
      Get.snackbar("Success", result.data?['message'] ?? "Status updated");
      fetchContacts();
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to update status");
    }
  }

  Future<void> updateNotes(int contactId, String notes) async {
    final result = await repository.updateContactNotes(contactId, notes);
    if (result.success) {
      Get.snackbar("Success", result.data?['message'] ?? "Notes updated");
      fetchContacts();
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to update notes");
    }
  }

  Future<void> deleteContact(int contactId) async {
    final result = await repository.deleteContact(contactId);
    if (result.success) {
      Get.snackbar("Success", "Contact removed");
      fetchContacts();
    } else {
      Get.snackbar("Error", result.error?.message ?? "Failed to delete contact");
    }
  }

  void setTab(int index) {
    selectedTab.value = index;
    fetchContacts();
  }
}
