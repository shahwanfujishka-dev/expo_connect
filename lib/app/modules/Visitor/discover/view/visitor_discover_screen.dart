import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../routes/app_routes.dart';
import '../controller/visitor_discover_controller.dart';

class VisitorDiscoverScreen extends GetView<VisitorDiscoverController> {
  const VisitorDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover exhibitors',
                    style: AppTextStyles.heading,
                  ),
                  SizedBox(height: 16.h),
                  _SearchBar(onChanged: controller.onSearch),
                  SizedBox(height: 16.h),
                  _CategoryFilters(),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final list = controller.filteredExhibitors;
                if (list.isEmpty) {
                  return const Center(child: Text("No exhibitors found"));
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final exhibitor = list[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        Routes.VISITOR_EXHIBITOR_DETAILS,
                        arguments: exhibitor,
                      ),
                      child: _ExhibitorCard(exhibitor: exhibitor),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search exhibitors, booths...',
          hintStyle: AppTextStyles.subText,
          icon: Icon(Icons.search, color: AppColors.textSecondary, size: 20.sp),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}

class _CategoryFilters extends GetView<VisitorDiscoverController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: controller.categories.map((cat) {
            final isSelected = controller.selectedCategory.value == cat;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => controller.selectCategory(cat),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ExhibitorCard extends StatelessWidget {
  const _ExhibitorCard({required this.exhibitor});
  final ExhibitorModel exhibitor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Text(
              exhibitor.initials,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exhibitor.name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${exhibitor.hall} • ${exhibitor.booth}",
                  style: AppTextStyles.subText,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
