import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/services/endpoints.dart';
import '../../visitor_drawer/VisitorDrawer.dart';
import '../../visitor_main/controller/visitor_main_controller.dart';
import '../controller/contact_details_controller.dart';

class VisitorContactDetailsScreen extends GetView<VisitorContactDetailsController> {
  const VisitorContactDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<VisitorMainController>();
    final exhibitor = controller.exhibitor;
    final logoUrl = exhibitor.logoUrl != null && exhibitor.logoUrl!.isNotEmpty
        ? "${Endpoints.storageUrl}${exhibitor.logoUrl}"
        : null;

    return Obx(() => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (mainController.isDrawerOpen.value) {
          mainController.closeDrawer();
        } else {
          Get.back();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20.sp),
                onPressed: () => Get.back(),
              ),
              title: Text('Contact Details', style: AppTextStyles.subheading),
              actions: [
                IconButton(
                  onPressed: mainController.toggleDrawer,
                  icon: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(Icons.menu_rounded, color: AppColors.primary, size: 20.sp),
                  ),
                ),
                Obx(() => IconButton(
                  onPressed: controller.toggleFavorite,
                  icon: Icon(
                    controller.isFavorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: controller.isFavorite.value ? Colors.red : AppColors.textSecondary,
                    size: 24.sp,
                  ),
                )),
                SizedBox(width: 8.w),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info Card
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70.r,
                          height: 70.r,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: logoUrl != null
                                ? Image.network(
                              logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildInitial(exhibitor.initials),
                            )
                                : _buildInitial(exhibitor.initials),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exhibitor.name,
                                style: AppTextStyles.heading.copyWith(fontSize: 18.sp),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                exhibitor.category,
                                style: AppTextStyles.subText.copyWith(color: AppColors.primary),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textSecondary),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${exhibitor.hall} • Booth ${exhibitor.booth}",
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Interaction Status Section
                  Text(
                    "INTERACTION STATUS",
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _StatusSelector(),
                  SizedBox(height: 32.h),

                  // Notes Section
                  Text(
                    "MY NOTES",
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _NotesField(),
                  SizedBox(height: 40.h),

                  // Action Button
                  Obx(() => PrimaryButton(
                    label: "Save Changes",
                    loading: controller.isUpdating.value,
                    onPressed: controller.saveNotes,
                  )),
                ],
              ),
            ),
          ),
          VisitorDrawer(
            isOpen: mainController.isDrawerOpen.value,
            onClose: mainController.closeDrawer,
            onLogout: mainController.logout,
          ),
        ],
      ),
    ));
  }

  Widget _buildInitial(String initials) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w800,
          fontSize: 24.sp,
        ),
      ),
    );
  }
}

class _StatusSelector extends GetView<VisitorContactDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: controller.statuses.map((status) {
        final isSelected = controller.currentStatus.value == status;
        return ChoiceChip(
          label: Text(status.capitalizeFirst!),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              controller.updateStatus(status);
            }
          },
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 1.w,
            ),
          ),
          showCheckmark: false,
          elevation: 0,
          pressElevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        );
      }).toList(),
    ));
  }
}

class _NotesField extends GetView<VisitorContactDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller.notesController,
        maxLines: 6,
        style: AppTextStyles.body.copyWith(fontSize: 14.sp, height: 1.5),
        decoration: InputDecoration(
          hintText: "Write down key takeaways, specific interests, or required follow-ups...",
          hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.r),
        ),
      ),
    );
  }
}
