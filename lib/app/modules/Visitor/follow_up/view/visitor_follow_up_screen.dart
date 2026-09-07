import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/visitor_follow_up_controller.dart';

class VisitorFollowUpScreen extends GetView<VisitorFollowUpController> {
  const VisitorFollowUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Post-expo follow-up', style: AppTextStyles.subheading),
      ),
      body: Obx(() => ListView.separated(
            padding: EdgeInsets.all(20.r),
            itemCount: controller.followUps.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final item = controller.followUps[index];
              return _FollowUpTile(
                item: item,
                onSchedule: () => controller.scheduleMeeting(item),
                onCall: () => controller.callExhibitor(item),
                onEmail: () => controller.sendEmail(item),
              );
            },
          )),
    );
  }
}

class _FollowUpTile extends StatelessWidget {
  const _FollowUpTile({
    required this.item,
    required this.onSchedule,
    required this.onCall,
    required this.onEmail,
  });

  final FollowUpModel item;
  final VoidCallback onSchedule;
  final VoidCallback onCall;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    final isDone = item.status == "Done";

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.primary : Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.exhibitorName,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.date,
                      style: AppTextStyles.subText.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDone ? AppColors.primarySoft : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isDone ? AppColors.primaryDark : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: "Schedule",
                  icon: Icons.calendar_today_outlined,
                  onTap: onSchedule,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActionButton(
                  label: "Call",
                  icon: Icons.phone_outlined,
                  onTap: onCall,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActionButton(
                  label: "Email",
                  icon: Icons.email_outlined,
                  onTap: onEmail,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18.sp, color: AppColors.textSecondary),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}
