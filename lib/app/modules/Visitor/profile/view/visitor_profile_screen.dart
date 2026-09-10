import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/visitor_profile_controller.dart';
import '../../visitor_main/controller/visitor_main_controller.dart';
import '../../visitor_appbar/VisitorAppBar.dart';

class VisitorProfileScreen extends GetView<VisitorProfileController> {
  const VisitorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<VisitorMainController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VisitorAppBar(
        title: 'My digital card',
        onMenuTap: mainController.toggleDrawer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DigitalCard(),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.shareCard,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(
                        "Share",
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: PrimaryButton(
                      label: "Save",
                      onPressed: controller.saveToGallery,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text("Profile Settings", style: AppTextStyles.subheading),
              SizedBox(height: 16.h),
              _SettingsTile(icon: Icons.person_outline, label: "Edit Profile", onTap: () {}),
              _SettingsTile(icon: Icons.notifications_none, label: "Notifications", onTap: () {}),
              _SettingsTile(icon: Icons.privacy_tip_outlined, label: "Privacy", onTap: () {}),
              _SettingsTile(
                icon: Icons.logout,
                label: "Logout",
                isDestructive: true,
                onTap: controller.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DigitalCard extends GetView<VisitorProfileController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 420.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1D8A4C),
            Color(0xFF0D3D22),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(32.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Obx(() => Text(
            controller.name.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          )),
          SizedBox(height: 4.h),
          Obx(() => Text(
            "${controller.role.value}, ${controller.company.value}",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          )),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.qr_code_2,
              size: 160.r,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.textSecondary,
          size: 20.sp,
        ),
      ),
      title: Text(
        label,
        style: AppTextStyles.body.copyWith(
          color: isDestructive ? Colors.red : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20.sp),
    );
  }
}
