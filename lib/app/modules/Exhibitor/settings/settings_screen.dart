import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import 'controller/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  void _showChangePasswordSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text("Change Password", style: AppTextStyles.subheading),
              SizedBox(height: 24.h),
              
              Obx(() => _PasswordField(
                label: "Current Password",
                controller: controller.currentPasswordController,
                obscureText: controller.obscureCurrent.value,
                onToggle: controller.toggleCurrent,
              )),
              SizedBox(height: 16.h),
              
              Obx(() => _PasswordField(
                label: "New Password",
                controller: controller.newPasswordController,
                obscureText: controller.obscureNew.value,
                onToggle: controller.toggleNew,
              )),
              SizedBox(height: 16.h),
              
              Obx(() => _PasswordField(
                label: "Confirm New Password",
                controller: controller.confirmNewPasswordController,
                obscureText: controller.obscureConfirm.value,
                onToggle: controller.toggleConfirm,
              )),
              
              SizedBox(height: 32.h),
              
              Obx(() => PrimaryButton(
                label: 'Update Password',
                loading: controller.isChangingPassword.value,
                onPressed: controller.changePassword,
              )),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        children: [
          Text("Account Security", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          SizedBox(height: 12.h),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            label: "Change Password",
            onTap: () => _showChangePasswordSheet(context),
          ),
          
          SizedBox(height: 32.h),
          Text("App Preferences", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          SizedBox(height: 12.h),
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: "Notifications",
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.language_rounded,
            label: "Language",
            trailing: Text("English", style: AppTextStyles.subText),
            onTap: () {},
          ),

          SizedBox(height: 32.h),
          Text("About", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          SizedBox(height: 12.h),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            label: "Version",
            trailing: Text("1.0.0", style: AppTextStyles.subText),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            label: "Terms & Conditions",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onToggle,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.background,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, size: 20.sp),
              onPressed: onToggle,
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primarySoft.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 20.sp),
        ),
        title: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      ),
    );
  }
}
