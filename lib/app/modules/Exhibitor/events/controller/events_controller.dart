import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/exhibitor_event_model.dart';
import '../../../../data/repositories/event_repository.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../data/providers/api_service.dart';
import 'package:intl/intl.dart';

class EventsController extends GetxController {
  final EventRepository _eventRepository = EventRepository();

  final RxList<ExhibitorEventModel> upcomingEvents = <ExhibitorEventModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  // Step management
  final RxInt currentStep = 1.obs;

  // ---------------- IDs carried through the flow ----------------
  final RxnInt expoId = RxnInt();
  final RxnInt hallId = RxnInt();
  final RxnInt stallId = RxnInt();

  // ---------------- Step 1: Event Selection/Creation ----------------
  final Rxn<ExhibitorEventModel> selectedUpcomingEvent = Rxn<ExhibitorEventModel>();
  final RxBool isCreatingNewEvent = false.obs;

  final nameController = TextEditingController();
  final venueController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final bannerFile = Rxn<dio.MultipartFile>();

  // Hall & Stall fields shown inline in the Create New Event form.
  final hallNameController = TextEditingController();
  final stallNumberController = TextEditingController();

  // ---------------- Step 2: Hall (dropdown-event path only) ----------------
  final RxList<HallModel> halls = <HallModel>[].obs;
  final RxBool isLoadingHalls = false.obs;
  final Rxn<HallModel> selectedHall = Rxn<HallModel>();
  final RxBool isCreatingNewHall = false.obs;
  final newHallNameController = TextEditingController();

  // ---------------- Step 3: Stall (dropdown-event path only) ----------------
  final RxList<StallModel> stalls = <StallModel>[].obs;
  final RxBool isLoadingStalls = false.obs;
  final Rxn<StallModel> selectedStall = Rxn<StallModel>();
  final RxBool isCreatingNewStall = false.obs;
  final newStallNumberController = TextEditingController();

  // ---------------- Event Details ----------------
  final Rxn<JoinedEventDetails> joinedDetails = Rxn<JoinedEventDetails>();
  final RxBool isLoadingDetails = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString selectedStatus = 'upcoming'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingEvents();
  }

  Future<void> fetchUpcomingEvents() async {
    isLoading.value = true;
    try {
      final result = await _eventRepository.getUpcomingEvents();
      if (result.success && result.data != null && result.data!.data != null) {
        upcomingEvents.assignAll(result.data!.data!.data);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Event Details & Update ====================

  Future<void> fetchEventDetails(int id) async {
    isLoadingDetails.value = true;
    joinedDetails.value = null;
    bannerFile.value = null; // Clear previous image selection
    try {
      final result = await _eventRepository.getJoinedEventDetails(id);
      if (result.success && result.data != null) {
        joinedDetails.value = result.data;
        final expo = result.data!.expo;
        
        nameController.text = expo.name;
        venueController.text = expo.venue ?? '';
        descriptionController.text = expo.description ?? '';
        startDateController.text = expo.startDate != null ? DateFormat('dd-MM-yyyy').format(expo.startDate!) : '';
        endDateController.text = expo.endDate != null ? DateFormat('dd-MM-yyyy').format(expo.endDate!) : '';
        selectedStatus.value = (expo.status ?? 'upcoming').toLowerCase();
      } else {
        Get.snackbar('Error', result.error?.message ?? 'Failed to load event details');
      }
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> updateDetails() async {
    if (joinedDetails.value == null) return;
    
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Event name cannot be empty');
      return;
    }

    isUpdating.value = true;
    try {
      final result = await _eventRepository.updateEventDetails(
        id: joinedDetails.value!.expo.id,
        name: nameController.text,
        venue: venueController.text,
        description: descriptionController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        status: selectedStatus.value,
        banner: bannerFile.value,
      );

      if (result.success) {
        Get.snackbar('Success', 'Event details updated successfully');
        fetchUpcomingEvents(); // Refresh list
        fetchEventDetails(joinedDetails.value!.expo.id); // Refresh details
      } else {
        Get.snackbar('Error', result.error?.message ?? 'Failed to update event details');
      }
    } finally {
      isUpdating.value = false;
    }
  }

  // ==================== Step Management ====================

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value == 4 && isCreatingNewEvent.value) {
      currentStep.value = 1;
    } else if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  // ==================== Step 1: Event ====================

  void selectUpcomingEvent(int? id) {
    if (id == null) return;
    final event = upcomingEvents.firstWhere((e) => e.id == id);
    selectedUpcomingEvent.value = event;
    expoId.value = event.id;
    isCreatingNewEvent.value = false;

    selectedHall.value = null;
    hallId.value = null;
    halls.clear();
    selectedStall.value = null;
    stallId.value = null;
    stalls.clear();
  }

  void toggleCreateNew() {
    _clearFields();
    isCreatingNewEvent.value = true;
    selectedUpcomingEvent.value = null;
    expoId.value = null;
  }

  void cancelCreateNew() {
    isCreatingNewEvent.value = false;
    _clearFields();
  }

  Future<void> proceedFromEventStep() async {
    if (isCreatingNewEvent.value) {
      if (nameController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter event name');
        return;
      }
      if (hallNameController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter hall name');
        return;
      }
      if (stallNumberController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter stall number');
        return;
      }
      await _createEventNow();
    } else {
      if (expoId.value == null) {
        Get.snackbar('Error', 'Please select an event or create a new one');
        return;
      }
      currentStep.value = 2;
      fetchHalls();
    }
  }

  Future<void> _createEventNow() async {
    isCreating.value = true;
    try {
      final result = await _eventRepository.createEventWithHallStall(
        name: nameController.text,
        venue: venueController.text,
        description: descriptionController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        hallName: hallNameController.text,
        stallNumber: stallNumberController.text,
        banner: bannerFile.value,
      );

      if (result.success && result.data != null) {
        expoId.value = result.data!.expoId;
        hallId.value = result.data!.hallId;
        stallId.value = result.data!.stallId;
        Get.snackbar('Success', 'Event created and joined successfully');
        currentStep.value = 4;
      } else {
        Get.snackbar('Error', result.error?.message ?? 'Failed to create event');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isCreating.value = false;
    }
  }

  // ==================== Step 2: Hall ====================

  Future<void> fetchHalls() async {
    if (expoId.value == null) return;
    isLoadingHalls.value = true;
    try {
      final result = await _eventRepository.getHalls(expoId.value!);
      if (result.success && result.data != null) {
        halls.assignAll(result.data!.halls);
      }
    } finally {
      isLoadingHalls.value = false;
    }
  }

  void selectHall(int? id) {
    if (id == null) return;
    final hall = halls.firstWhere((h) => h.id == id);
    selectedHall.value = hall;
    hallId.value = hall.id;
    isCreatingNewHall.value = false;

    selectedStall.value = null;
    stallId.value = null;
    stalls.clear();
  }

  void toggleCreateNewHall() {
    isCreatingNewHall.value = true;
    selectedHall.value = null;
    hallId.value = null;
  }

  void cancelCreateNewHall() {
    isCreatingNewHall.value = false;
    newHallNameController.clear();
  }

  Future<void> proceedFromHallStep() async {
    if (isCreatingNewHall.value) {
      if (newHallNameController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter hall name');
        return;
      }
      isCreating.value = true;
      try {
        final result = await _eventRepository.createHall(
          eventId: expoId.value!,
          name: newHallNameController.text,
        );
        if (result.success && result.data != null) {
          hallId.value = result.data!.id;
          Get.snackbar('Success', 'Hall created successfully');
          currentStep.value = 3;
          fetchStalls();
        } else {
          Get.snackbar('Error', result.error?.message ?? 'Failed to create hall');
        }
      } catch (e) {
        Get.snackbar('Error', 'An unexpected error occurred');
      } finally {
        isCreating.value = false;
      }
    } else {
      if (hallId.value == null) {
        Get.snackbar('Error', 'Please select a hall or create a new one');
        return;
      }
      currentStep.value = 3;
      fetchStalls();
    }
  }

  // ==================== Step 3: Stall ====================

  Future<void> fetchStalls() async {
    if (hallId.value == null) return;
    isLoadingStalls.value = true;
    try {
      final result = await _eventRepository.getStalls(hallId.value!);
      if (result.success && result.data != null) {
        stalls.assignAll(result.data!.stalls);
      }
    } finally {
      isLoadingStalls.value = false;
    }
  }

  void selectStall(int? id) {
    if (id == null) return;
    final stall = stalls.firstWhere((s) => s.id == id);
    if (stall.companyName != null) {
      Get.snackbar(
        'Stall Occupied',
        'Stall ${stall.stallNumber} is already taken by ${stall.companyName}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    selectedStall.value = stall;
    stallId.value = stall.id;
    isCreatingNewStall.value = false;
  }

  void toggleCreateNewStall() {
    isCreatingNewStall.value = true;
    selectedStall.value = null;
    stallId.value = null;
  }

  void cancelCreateNewStall() {
    isCreatingNewStall.value = false;
    newStallNumberController.clear();
  }

  Future<void> proceedFromStallStep() async {
    if (isCreatingNewStall.value) {
      if (newStallNumberController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter stall number');
        return;
      }
      isCreating.value = true;
      try {
        final result = await _eventRepository.createStall(
          hallId: hallId.value!,
          stallNumber: newStallNumberController.text,
        );
        if (result.success && result.data != null) {
          stallId.value = result.data!.id;
          Get.snackbar('Success', 'Stall created successfully');
          currentStep.value = 4;
        } else {
          Get.snackbar('Error', result.error?.message ?? 'Failed to create stall');
        }
      } catch (e) {
        Get.snackbar('Error', 'An unexpected error occurred');
      } finally {
        isCreating.value = false;
      }
    } else {
      if (stallId.value == null) {
        Get.snackbar('Error', 'Please select a stall or create a new one');
        return;
      }
      currentStep.value = 4;
    }
  }

  // ==================== Step 4: Join ====================

  Future<void> confirmJoin() async {
    if (expoId.value == null || hallId.value == null || stallId.value == null) {
      Get.snackbar('Error', 'Missing information to join event.');
      return;
    }
    isCreating.value = true;
    try {
      final result = await _eventRepository.joinEvent(
        expoId: expoId.value!,
        hallId: hallId.value!,
        stallId: stallId.value!,
      );

      if (result.success) {
        Get.back();
        Get.snackbar('Success', 'You have joined the event successfully.');
        fetchUpcomingEvents();
        currentStep.value = 1;
        _clearFields();
      } else {
        Get.snackbar('Error', result.error?.message ?? 'Failed to join event');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isCreating.value = false;
    }
  }

  void _clearFields() {
    nameController.clear();
    venueController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
    hallNameController.clear();
    stallNumberController.clear();
    bannerFile.value = null;
    selectedUpcomingEvent.value = null;
    isCreatingNewEvent.value = false;
    expoId.value = null;
    hallId.value = null;
    stallId.value = null;
    halls.clear();
    selectedHall.value = null;
    isCreatingNewHall.value = false;
    newHallNameController.clear();
    stalls.clear();
    selectedStall.value = null;
    isCreatingNewStall.value = false;
    newStallNumberController.clear();
    selectedStatus.value = 'upcoming';
  }

  @override
  void onClose() {
    nameController.dispose();
    venueController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    hallNameController.dispose();
    stallNumberController.dispose();
    newHallNameController.dispose();
    newStallNumberController.dispose();
    super.onClose();
  }
}
