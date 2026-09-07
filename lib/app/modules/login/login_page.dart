import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/utils/app_colors.dart';
import 'controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48.h),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'EC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              Text('Welcome back', style: AppTextStyles.heading),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue to Expo Connect.',
                style: AppTextStyles.subText,
              ),
              SizedBox(height: 32.h),

              // Email
              Text('Email', style: AppTextStyles.body),
              SizedBox(height: 8.h),
              _InputField(
                controller: controller.emailController,
                hint: 'you@company.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => controller.errorText.value = null,
              ),
              SizedBox(height: 18.h),

              // Password
              Text('Password', style: AppTextStyles.body),
              SizedBox(height: 8.h),
              Obx(
                () => _InputField(
                  controller: controller.passwordController,
                  hint: 'Enter your password',
                  obscureText: !controller.isPasswordVisible.value,
                  onChanged: (_) => controller.errorText.value = null,
                  suffix: IconButton(
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.forgotPasswordTapped,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),
              Obx(
                () => controller.errorText.value != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          controller.errorText.value!,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const Spacer(),
              Obx(
                () => PrimaryButton(
                  label: 'Sign in',
                  enabled: true,
                  loading: controller.isSubmitting.value,
                  onPressed: controller.signInTapped,
                ),
              ),
              SizedBox(height: 18.h),
              Center(
                child: GestureDetector(
                  onTap: controller.signUpTapped,
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: AppTextStyles.subText,
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.subText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
