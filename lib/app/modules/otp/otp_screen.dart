import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/utils/app_colors.dart';
import 'controller/otp_controller.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

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
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                  size: 24.sp,
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              SizedBox(height: 12.h),
              Text(controller.title, style: AppTextStyles.heading),
              SizedBox(height: 8.h),
              Text(controller.subtitle, style: AppTextStyles.subText),
              SizedBox(height: 32.h),
              // Adjusted Row for 6 digits to fit screen width
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  OtpController.otpLength,
                  (i) => _OtpBox(index: i, controller: controller),
                ),
              ),
              SizedBox(height: 12.h),
              Obx(
                () => controller.errorText.value != null
                    ? Text(
                        controller.errorText.value!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: 32.h),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: AppTextStyles.subText.copyWith(fontSize: 14.sp),
                    ),
                    controller.isResending.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.primary.withOpacity(0.3),
                            highlightColor: AppColors.primary.withOpacity(0.1),
                            child: Container(
                              width: 80.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: controller.secondsLeft.value > 0
                                ? null
                                : controller.resendTapped,
                            child: Text(
                              controller.secondsLeft.value > 0
                                  ? 'Wait ${(controller.secondsLeft.value ~/ 60).toString().padLeft(2, '0')}:'
                                        '${(controller.secondsLeft.value % 60).toString().padLeft(2, '0')}'
                                  :
                              'Resend code',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: controller.secondsLeft.value > 0
                                    ? AppColors.textSecondary
                                    : AppColors.primary,
                                decoration: controller.secondsLeft.value > 0
                                    ? TextDecoration.none
                                    : TextDecoration.underline,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const Spacer(),
              Obx(
                () => PrimaryButton(
                  label: 'Verify & continue',
                  enabled: controller.isComplete,
                  loading: controller.isVerifying.value,
                  onPressed: controller.verifyTapped,
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

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.index, required this.controller});

  final int index;
  final OtpController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 60.h,
      child: TextField(
        controller: controller.digitControllers[index],
        focusNode: controller.focusNodes[index],
        onChanged: (v) => controller.onDigitChanged(index, v),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
          ),
        ),
      ),
    );
  }
}
