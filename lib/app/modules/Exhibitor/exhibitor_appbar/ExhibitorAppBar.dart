import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/models/event_dropdown_model.dart';
import 'controller/event_dropdown_controller.dart';

/// Shared top bar for every Exhibitor screen.
class ExhibitorAppBar extends StatelessWidget implements PreferredSizeWidget {
  ExhibitorAppBar({
    super.key,
    required this.onMenuTap,
  });

  final VoidCallback onMenuTap;
  final EventDropdownController controller = Get.put(EventDropdownController());

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leadingWidth: 68.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: _SquareIconButton(icon: Icons.menu_rounded, onTap: onMenuTap),
      ),
      actions: [
        Obx(() {
          if (controller.isLoading.value && controller.events.isEmpty) {
            return _buildShimmerLoading();
          }

          if (controller.events.isEmpty) {
            return const SizedBox.shrink();
          }

          return _buildEventDropdown();
        }),
        SizedBox(width: 20.w),
      ],
    );
  }

  Widget _buildEventDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EventModel>(
          value: controller.selectedEvent.value,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp, color: AppColors.textSecondary),
          elevation: 16,
          style: AppTextStyles.body.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600),
          borderRadius: BorderRadius.circular(12.r),
          dropdownColor: AppColors.surface,
          onChanged: (EventModel? newValue) {
            controller.setSelectedEvent(newValue);
          },
          items: controller.events.map<DropdownMenuItem<EventModel>>((EventModel event) {
            return DropdownMenuItem<EventModel>(
              value: event,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 160.w),
                child: Text(
                  event.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.border.withOpacity(0.3),
      highlightColor: AppColors.surface,
      child: Container(
        width: 160.w,
        height: 40.h,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border, width: 1.w),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
