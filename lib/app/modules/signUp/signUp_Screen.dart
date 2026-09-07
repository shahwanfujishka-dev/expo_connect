import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/utils/app_colors.dart';
import 'controller/signUp_controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

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
              SizedBox(height: 24.h),
              IconButton(
                onPressed: Get.back,
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              SizedBox(height: 20.h),
              Text('Create your account', style: AppTextStyles.heading),
              SizedBox(height: 8.h),
              Text(
                'Enter your email and we\'ll send you a code to verify it.',
                style: AppTextStyles.subText,
              ),
              SizedBox(height: 32.h),
              Text('Email', style: AppTextStyles.body),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: controller.emailController,
                  onChanged: controller.onEmailChanged,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'you@company.com',
                    hintStyle: AppTextStyles.subText,
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                    () => controller.errorText.value != null
                    ? Padding(
                  padding: EdgeInsets.only(top: 4.h),
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
                  label: 'Send OTP',
                  enabled: controller.isValid.value,
                  loading: controller.isSubmitting.value,
                  onPressed: controller.sendOtpTapped,
                ),
              ),
              SizedBox(height: 18.h),
              Center(
                child: GestureDetector(
                  onTap: Get.back,
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.subText,
                      children: [
                        TextSpan(
                          text: 'Sign in',
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
