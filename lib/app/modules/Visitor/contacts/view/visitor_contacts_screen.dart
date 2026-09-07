import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../controller/visitor_contacts_controller.dart';

class VisitorContactsScreen extends GetView<VisitorContactsController> {
  const VisitorContactsScreen({super.key});

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
                    'My contact book',
                    style: AppTextStyles.heading,
                  ),
                  SizedBox(height: 20.h),
                  _TabSelector(),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.contacts.isEmpty) {
                  return const Center(child: Text("No contacts saved"));
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  itemCount: controller.contacts.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final exhibitor = controller.contacts[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        Routes.VISITOR_EXHIBITOR_DETAILS,
                        arguments: exhibitor,
                      ),
                      child: _ContactTile(exhibitor: exhibitor),
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

class _TabSelector extends GetView<VisitorContactsController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tabItem("All (4)", 0),
        SizedBox(width: 12.w),
        _tabItem("Recent", 1),
      ],
    );
  }

  Widget _tabItem(String label, int index) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return GestureDetector(
        onTap: () => controller.setTab(index),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            if (isSelected)
              Container(
                width: 20.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.exhibitor});
  final dynamic exhibitor;

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
            width: 44.r,
            height: 44.r,
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
                fontSize: 15.sp,
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
                  "High Interest",
                  style: AppTextStyles.subText.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
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
