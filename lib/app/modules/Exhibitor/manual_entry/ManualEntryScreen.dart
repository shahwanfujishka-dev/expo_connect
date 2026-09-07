import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import 'controller/manual_controller.dart';

class ManualEntryScreen extends GetView<ManualEntryController> {
  const ManualEntryScreen({super.key});

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
              SizedBox(height: 12.h),
              Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(width: 4.w),
                  Text('Manual entry', style: AppTextStyles.heading),
                ],
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const _FieldLabel('Full name *'),
                    _FormField(controller: controller.nameController, hint: 'Enter full name'),
                    SizedBox(height: 16.h),
                    
                    const _FieldLabel('Email *'),
                    _FormField(
                      controller: controller.emailController,
                      hint: 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),

                    const _FieldLabel('Company name *'),
                    _FormField(controller: controller.companyNameController, hint: 'Enter company name'),
                    SizedBox(height: 16.h),

                    const _FieldLabel('Designation'),
                    _FormField(controller: controller.designationController, hint: 'Enter designation'),
                    SizedBox(height: 16.h),

                    const _FieldLabel('Mobile number *'),
                    _FormField(
                      controller: controller.phoneController,
                      hint: 'Enter mobile number',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),

                    const _FieldLabel('WhatsApp number'),
                    _FormField(
                      controller: controller.whatsappController,
                      hint: 'Enter WhatsApp number',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),

                    const _FieldLabel('Website'),
                    _FormField(
                      controller: controller.websiteController,
                      hint: 'Enter website URL',
                      keyboardType: TextInputType.url,
                    ),
                    SizedBox(height: 16.h),

                    const _FieldLabel('Address'),
                    _FormField(
                      controller: controller.addressController, 
                      hint: 'Enter address',
                      maxLines: 3,
                    ),
                    SizedBox(height: 8.h),
                    
                    Obx(
                      () => controller.errorText.value != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                              child: Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  controller.errorText.value!,
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                child: Obx(
                  () => PrimaryButton(
                    label: 'Save lead',
                    enabled: !controller.isSaving.value,
                    loading: controller.isSaving.value,
                    onPressed: controller.saveLeadTapped,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          letterSpacing: 0.3,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.controller, required this.hint, this.keyboardType, this.maxLines = 1});

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.subText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }
}
