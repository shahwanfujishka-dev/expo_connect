import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import 'controller/business_card_controller.dart';

class BusinessCardScanScreen extends GetView<BusinessCardScanController> {
  const BusinessCardScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1A12),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: Icon(Icons.close_rounded, color: Colors.white, size: 24.sp),
                  ),
                  const Spacer(),
                  Text(
                    'Scan business card',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.sp),
                  ),
                  const Spacer(),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(
                  () => GestureDetector(
                    onTap: controller.state.value == CardScanState.idle
                        ? controller.captureAndReadTapped
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.white24, width: 1.w),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (controller.isCameraInitialized.value && controller.cameraController != null)
                              CameraPreview(controller.cameraController!)
                            else
                              Center(
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white.withOpacity(0.2),
                                  size: 48.sp,
                                ),
                              ),
                            if (controller.state.value == CardScanState.reading)
                              Container(
                                color: Colors.black45,
                                child: const Center(
                                  child: CircularProgressIndicator(color: AppColors.primary),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Obx(() {
                  switch (controller.state.value) {
                    case CardScanState.idle:
                      return const _IdleHint();
                    case CardScanState.reading:
                      return const _ReadingHint();
                    case CardScanState.done:
                      return _ExtractedFields(controller: controller);
                    case CardScanState.failed:
                      return _FailedHint(onRetry: controller.retakeTapped);
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleHint extends StatelessWidget {
  const _IdleHint();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tap the frame to capture the card',
        style: AppTextStyles.subText,
      ),
    );
  }
}

class _ReadingHint extends StatelessWidget {
  const _ReadingHint();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('AI OCR — Reading card…', style: AppTextStyles.body),
    );
  }
}

class _FailedHint extends StatelessWidget {
  const _FailedHint({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Couldn\'t read that card clearly.', style: AppTextStyles.body),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: onRetry,
          child: Text('Try again', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
    );
  }
}

class _ExtractedFields extends StatelessWidget {
  const _ExtractedFields({required this.controller});
  final BusinessCardScanController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Confirm details', style: AppTextStyles.body),
          SizedBox(height: 14.h),
          _ReadRow(label: 'Name', controller: controller.nameController),
          SizedBox(height: 10.h),
          _ReadRow(label: 'Company', controller: controller.companyController),
          SizedBox(height: 10.h),
          _ReadRow(label: 'Phone', controller: controller.phoneController),
          SizedBox(height: 18.h),
          Obx(
            () => PrimaryButton(
              label: 'Confirm details',
              enabled: true,
              loading: controller.isSaving.value,
              onPressed: controller.confirmDetailsTapped,
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: TextButton(
              onPressed: controller.retakeTapped,
              child: Text(
                'Retake',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadRow extends StatelessWidget {
  const _ReadRow({required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            style: AppTextStyles.body.copyWith(fontSize: 14.sp),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
