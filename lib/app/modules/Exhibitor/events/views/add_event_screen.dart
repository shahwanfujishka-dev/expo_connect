import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/events_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class AddEventScreen extends GetView<EventsController> {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Add Event', style: AppTextStyles.subheading),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            _buildStepper(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: _buildCurrentStep(context),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepper() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          _buildStepItem(1, 'Event'),
          _buildStepDivider(),
          _buildStepItem(2, 'Hall'),
          _buildStepDivider(),
          _buildStepItem(3, 'Stall'),
          _buildStepDivider(),
          _buildStepItem(4, 'Join'),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String label) {
    bool isCompleted = controller.currentStep.value > step;
    bool isActive = controller.currentStep.value == step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isActive ? AppColors.primary : AppColors.border,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 18.r)
                  : Text(
                '$step',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return Container(
      width: 30.w,
      height: 1.h,
      color: AppColors.border,
      margin: EdgeInsets.only(bottom: 20.h),
    );
  }

  Widget _buildCurrentStep(BuildContext context) {
    switch (controller.currentStep.value) {
      case 1:
        return _buildEventStep(context);
      case 2:
        return _buildHallStep();
      case 3:
        return _buildStallStep();
      case 4:
        return _buildJoinStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------- Step 1: Event ----------------

  Widget _buildEventStep(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Upcoming Event', style: AppTextStyles.subheading),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              dropdownColor: Colors.white,
              isExpanded: true,
              hint: const Text('Select an event'),
              value: controller.selectedUpcomingEvent.value?.id,
              items: controller.upcomingEvents.map((event) {
                return DropdownMenuItem<int>(
                  value: event.id,
                  child: Text(
                    event.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (val) => controller.selectUpcomingEvent(val),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        if (!controller.isCreatingNewEvent.value) ...[
          Center(child: Text('OR', style: AppTextStyles.subText)),
          SizedBox(height: 16.h),
          Center(
            child: OutlinedButton.icon(
              onPressed: controller.toggleCreateNew,
              icon: const Icon(Icons.add),
              label: const Text('Create New Event'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
        ],
        if (controller.isCreatingNewEvent.value) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Create New Event', style: AppTextStyles.subheading),
              TextButton(
                onPressed: controller.cancelCreateNew,
                child: const Text('Cancel'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildTextField(controller.nameController, 'Event Name', Icons.event,
              hint: 'e.g. Food & Beverage Expo 2024'),
          _buildTextField(controller.venueController, 'Venue', Icons.location_on,
              hint: 'e.g. Exhibition Center, City, Country'),
          _buildTextField(controller.descriptionController, 'Description', Icons.description,
              maxLines: 3,
              hint: 'Briefly describe the event, its purpose, and audience'),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller.startDateController,
                  'Start Date',
                  Icons.calendar_today,
                  hint: 'dd-mm-yyyy',
                  readOnly: true,
                  onTap: () => _selectDate(context, controller.startDateController),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTextField(
                  controller.endDateController,
                  'End Date',
                  Icons.calendar_today,
                  hint: 'dd-mm-yyyy',
                  readOnly: true,
                  onTap: () => _selectDate(context, controller.endDateController),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text('Event Banner', style: AppTextStyles.body),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
              ),
              child: controller.bannerFile.value == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 40.r, color: AppColors.textSecondary),
                  SizedBox(height: 8.h),
                  Text('Upload Banner Image', style: AppTextStyles.subText),
                ],
              )
                  : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      File(controller.bannerFile.value!.filename!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => controller.bannerFile.value = null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text('Hall & Stall', style: AppTextStyles.body),
          SizedBox(height: 8.h),
          _buildTextField(controller.hallNameController, 'Hall Name', Icons.home_work,
              hint: 'e.g. Hall A'),
          _buildTextField(controller.stallNumberController, 'Stall Number', Icons.door_front_door,
              hint: 'e.g. A-12'),
        ],
      ],
    ));
  }

  Future<void> _selectDate(BuildContext context, TextEditingController textController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      textController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final fileName = path.basename(image.path);
      controller.bannerFile.value = await dio.MultipartFile.fromFile(
        image.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      );
    }
  }

  // ---------------- Step 2: Hall ----------------

  Widget _buildHallStep() {
    return Obx(() {
      if (controller.isLoadingHalls.value) {
        return const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: CircularProgressIndicator()));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Hall', style: AppTextStyles.subheading),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                dropdownColor: Colors.white,
                isExpanded: true,
                hint: const Text('Select a hall'),
                value: controller.selectedHall.value?.id,
                items: controller.halls.map((hall) {
                  return DropdownMenuItem<int>(
                    value: hall.id,
                    child: Text(hall.name, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (val) => controller.selectHall(val),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          if (!controller.isCreatingNewHall.value) ...[
            Center(child: Text('OR', style: AppTextStyles.subText)),
            SizedBox(height: 16.h),
            Center(
              child: OutlinedButton.icon(
                onPressed: controller.toggleCreateNewHall,
                icon: const Icon(Icons.add),
                label: const Text('Create New Hall'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
          ],
          if (controller.isCreatingNewHall.value) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Create New Hall', style: AppTextStyles.subheading),
                TextButton(
                  onPressed: controller.cancelCreateNewHall,
                  child: const Text('Cancel'),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildTextField(controller.newHallNameController, 'Hall Name', Icons.home_work,
                hint: 'e.g. Hall A'),
          ],
        ],
      );
    });
  }

  // ---------------- Step 3: Stall ----------------

  Widget _buildStallStep() {
    return Obx(() {
      if (controller.isLoadingStalls.value) {
        return const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: CircularProgressIndicator()));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Stall', style: AppTextStyles.subheading),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                dropdownColor: Colors.white,
                isExpanded: true,
                hint: const Text('Select a stall'),
                value: controller.selectedStall.value?.id,
                items: controller.stalls.map((stall) {
                  bool isOccupied = stall.companyName != null;
                  return DropdownMenuItem<int>(
                    value: stall.id,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(stall.stallNumber, style: const TextStyle(color: Colors.black)),
                        if (isOccupied)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Occupied by ${stall.companyName}',
                              style: AppTextStyles.caption.copyWith(color: AppColors.error, fontSize: 10.sp),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => controller.selectStall(val),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          if (!controller.isCreatingNewStall.value) ...[
            Center(child: Text('OR', style: AppTextStyles.subText)),
            SizedBox(height: 16.h),
            Center(
              child: OutlinedButton.icon(
                onPressed: controller.toggleCreateNewStall,
                icon: const Icon(Icons.add),
                label: const Text('Create New Stall'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
          ],
          if (controller.isCreatingNewStall.value) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Create New Stall', style: AppTextStyles.subheading),
                TextButton(
                  onPressed: controller.cancelCreateNewStall,
                  child: const Text('Cancel'),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildTextField(controller.newStallNumberController, 'Stall Number', Icons.door_front_door,
                hint: 'e.g. A-12'),
          ],
        ],
      );
    });
  }

  // ---------------- Step 4: Join ----------------

  Widget _buildJoinStep() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: AppTextStyles.subheading),
        SizedBox(height: 20.h),
        _buildSummaryItem('Event', controller.nameController.text.isNotEmpty
            ? controller.nameController.text
            : controller.selectedUpcomingEvent.value?.name ?? ''),
        _buildSummaryItem('Venue', controller.venueController.text.isNotEmpty
            ? controller.venueController.text
            : controller.selectedUpcomingEvent.value?.venue ?? ''),
        _buildSummaryItem('Dates', "${controller.startDateController.text} to ${controller.endDateController.text}"),
        _buildSummaryItem('Hall', controller.hallNameController.text.isNotEmpty
            ? controller.hallNameController.text
            : controller.selectedHall.value?.name ??
            controller.newHallNameController.text),
        _buildSummaryItem('Stall', controller.stallNumberController.text.isNotEmpty
            ? controller.stallNumberController.text
            : controller.selectedStall.value?.stallNumber ?? controller.newStallNumberController.text),
        SizedBox(height: 40.h),
        const Center(
          child: Text(
            'Confirm to join this event',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    ));
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80.w, child: Text(label, style: AppTextStyles.subText)),
          Expanded(child: Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        String? hint,
        int maxLines = 1,
        bool readOnly = false,
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6)),
          prefixIcon: Icon(icon, size: 20.r),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Obx(() {
        return Row(
          children: [
            if (controller.currentStep.value > 1)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.previousStep(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (controller.currentStep.value > 1) SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: controller.currentStep.value == 4 ? 'Confirm & Join' : 'Next',
                loading: controller.isCreating.value,
                onPressed: () async {
                  switch (controller.currentStep.value) {
                    case 1:
                      await controller.proceedFromEventStep();
                      break;
                    case 2:
                      await controller.proceedFromHallStep();
                      break;
                    case 3:
                      await controller.proceedFromStallStep();
                      break;
                    case 4:
                      await controller.confirmJoin();
                      break;
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
