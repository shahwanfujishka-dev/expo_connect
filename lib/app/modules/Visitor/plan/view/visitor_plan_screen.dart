import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../controller/visitor_plan_controller.dart';

class VisitorPlanScreen extends GetView<VisitorPlanController> {
  const VisitorPlanScreen({super.key});

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
                    'My expo plan',
                    style: AppTextStyles.heading,
                  ),
                  SizedBox(height: 20.h),
                  _TabSelector(),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.plannedExhibitors.isEmpty) {
                  return const Center(child: Text("Your plan is empty"));
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 80.h),
                  itemCount: controller.plannedExhibitors.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final exhibitor = controller.plannedExhibitors[index];
                    return _PlanTile(
                      exhibitor: exhibitor,
                      status: index == 0 ? "Visited" : "Planned",
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: PrimaryButton(
          label: "Add to plan",
          onPressed: () => Get.toNamed(Routes.VISITOR_MAIN), // Should go to discover
        ),
      ),
    );
  }
}

class _TabSelector extends GetView<VisitorPlanController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tabItem("Before", 0),
        SizedBox(width: 8.w),
        _tabItem("During", 1),
        SizedBox(width: 8.w),
        _tabItem("After", 2),
      ],
    );
  }

  Widget _tabItem(String label, int index) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.setTab(index),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({required this.exhibitor, required this.status});
  final dynamic exhibitor;
  final String status;

  @override
  Widget build(BuildContext context) {
    final isVisited = status == "Visited";
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
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(
              exhibitor.initials,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
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
                Text(
                  "11:30 AM • Booth A52",
                  style: AppTextStyles.subText.copyWith(fontSize: 11.sp),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isVisited ? AppColors.primarySoft : AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: isVisited ? AppColors.primary : AppColors.border),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: isVisited ? AppColors.primaryDark : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
