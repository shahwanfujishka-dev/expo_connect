import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../Exhibitor/exhibitor_profile/widgets/profile_widgets.dart';
import '../controller/visitor_complete_profile_controller.dart';

class VisitorCompleteProfileScreen extends GetView<VisitorCompleteProfileController> {
  const VisitorCompleteProfileScreen({super.key});

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text('Complete your profile', style: AppTextStyles.heading)
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.15, end: 0),
              SizedBox(height: 8.h),
              Text(
                'Let others know who you are.',
                style: AppTextStyles.subText,
              ).animate().fadeIn(delay: 50.ms, duration: 300.ms).slideY(begin: 0.15, end: 0),
              SizedBox(height: 28.h),

              // Avatar Picker
              Center(
                child: GestureDetector(
                  onTap: () => _showImagePicker(context),
                  child: Obx(
                    () => Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            image: controller.selectedAvatar.value != null
                                ? DecorationImage(
                                    image: FileImage(controller.selectedAvatar.value!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: controller.selectedAvatar.value == null
                              ? Icon(Icons.person_add_alt_1_outlined,
                                  color: AppColors.textSecondary, size: 30.sp)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms).scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),
              SizedBox(height: 24.h),

              ProfileWidgets.FieldLabel('Full Name *'),
              ProfileWidgets.FormField(
                controller: controller.nameController,
                hint: 'Enter your full name',
              ),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('Phone Number *'),
              ProfileWidgets.FormField(
                controller: controller.phoneController,
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('WhatsApp (optional)'),
              ProfileWidgets.FormField(
                controller: controller.whatsappController,
                hint: 'Enter WhatsApp number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('Set Password *'),
              Obx(() => ProfileWidgets.FormField(
                    controller: controller.passwordController,
                    hint: 'Minimum 8 characters',
                    obscureText: controller.obscurePassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('Confirm Password *'),
              Obx(() => ProfileWidgets.FormField(
                    controller: controller.confirmPasswordController,
                    hint: 'Re-enter your password',
                    obscureText: controller.obscureConfirmPassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),
              
              Obx(() => AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: !controller.passwordsMatch.value
                        ? Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              'Passwords do not match',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  )),

              SizedBox(height: 24.h),

              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: controller.errorText.value != null
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.error.withOpacity(0.2)),
                            ),
                            child: Text(
                              controller.errorText.value!,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              Obx(
                () => PrimaryButton(
                  label: 'Complete Profile',
                  loading: controller.isSubmitting.value,
                  onPressed: controller.saveTapped,
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
