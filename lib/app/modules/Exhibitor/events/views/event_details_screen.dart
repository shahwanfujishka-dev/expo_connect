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
import '../../../../data/services/endpoints.dart';

class EventDetailsScreen extends GetView<EventsController> {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Event Details', style: AppTextStyles.subheading),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.joinedDetails.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60.r, color: AppColors.error),
                SizedBox(height: 16.h),
                Text('Could not load event details', style: AppTextStyles.body),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                )
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Event Information'),
              _buildTextField(controller.nameController, 'Event Name', Icons.event),
              _buildTextField(controller.venueController, 'Venue', Icons.location_on),
              _buildTextField(controller.descriptionController, 'Description', Icons.description, maxLines: 3),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller.startDateController,
                      'Start Date',
                      Icons.calendar_today,
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
                      readOnly: true,
                      onTap: () => _selectDate(context, controller.endDateController),
                    ),
                  ),
                ],
              ),
              _buildStatusDropdown(),
              SizedBox(height: 16.h),
              Text('Event Banner', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              _buildBannerPicker(),
              SizedBox(height: 24.h),
              _buildSectionHeader('Participation Details'),
              _buildInfoTile('Hall', controller.joinedDetails.value!.hallName, Icons.home_work),
              _buildInfoTile('Stall Number', controller.joinedDetails.value!.stallNumber, Icons.door_front_door),
              SizedBox(height: 32.h),
              PrimaryButton(
                label: 'Save Changes',
                loading: controller.isUpdating.value,
                onPressed: () => controller.updateDetails(),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.subheading.copyWith(color: AppColors.primary, fontSize: 18.sp),
          ),
          Container(
            height: 2.h,
            width: 40.w,
            color: AppColors.primary,
            margin: EdgeInsets.only(top: 4.h),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.r, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
            child: Text('Status', style: AppTextStyles.caption),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Colors.white,
                value: controller.selectedStatus.value,
                items: ['upcoming', 'live', 'completed'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalizeFirst!, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.selectedStatus.value = val;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerPicker() {
    return Obx(() => GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: controller.bannerFile.value == null && controller.joinedDetails.value?.expo.banner == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 48.r, color: AppColors.textSecondary),
                  SizedBox(height: 8.h),
                  Text('Upload New Banner', style: AppTextStyles.subText),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: controller.bannerFile.value != null
                        ? Image.file(File(controller.bannerFile.value!.filename!), fit: BoxFit.cover)
                        : Image.network(
                            "${Endpoints.baseUrl}/${controller.joinedDetails.value!.expo.banner}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                          ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 20.r,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ));
  }

  Future<void> _selectDate(BuildContext context, TextEditingController textController) async {
    DateTime initialDate = DateTime.now();
    if (textController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd-MM-yyyy').parse(textController.text);
      } catch (e) {}
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          prefixIcon: Icon(icon, size: 22.r, color: AppColors.primary),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
