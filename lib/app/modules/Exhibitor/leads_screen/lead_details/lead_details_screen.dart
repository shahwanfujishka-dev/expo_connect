import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/lead.dart';
import 'controller/lead_details_controller.dart';

class LeadDetailsScreen extends GetView<LeadDetailsController> {
  const LeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lead = controller.lead;
    final initials = lead.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Text('Lead profile', style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundColor: AppColors.primarySoft,
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lead.name, style: AppTextStyles.heading.copyWith(fontSize: 20.sp)),
                        SizedBox(height: 4.h),
                        Text(
                          '${lead.title}, ${lead.company}',
                          style: AppTextStyles.subText.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Call',
                      icon: Icons.call,
                      onPressed: controller.callLead,
                      isPrimary: true,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ActionButton(
                      label: 'WhatsApp',
                      icon: Icons.chat_bubble,
                      onPressed: controller.whatsappLead,
                      isPrimary: true,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ActionButton(
                      label: 'Email',
                      icon: Icons.email_outlined,
                      onPressed: controller.emailLead,
                      isPrimary: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Wrap(
                spacing: 8.w,
                children: [
                  _Tag(label: '${lead.temperature.label} lead', color: _getTemperatureColor(lead.temperature)),
                  const _Tag(label: 'Bulk order', color: AppColors.textSecondary),
                ],
              ),
              SizedBox(height: 24.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border, width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOTES',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      controller.notesController.text,
                      style: AppTextStyles.body.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTemperatureColor(LeadTemperature temperature) {
    switch (temperature) {
      case LeadTemperature.hot: return AppColors.error;
      case LeadTemperature.warm: return const Color(0xFFB98A1E);
      case LeadTemperature.cold: return AppColors.textSecondary;
      case LeadTemperature.newLead: return AppColors.primary;
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isPrimary,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primaryDark : AppColors.surface,
        foregroundColor: isPrimary ? Colors.white : AppColors.textPrimary,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: isPrimary ? BorderSide.none : BorderSide(color: AppColors.border, width: 1.w),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(icon, size: 16.sp),
          // SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
