import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import '../../../core/utils/app_colors.dart';
import 'controller/exhibitor_profile_controller.dart';
import 'widgets/profile_widgets.dart';

class ExhibitorProfileScreen extends GetView<ExhibitorProfileController> {
  const ExhibitorProfileScreen({super.key});

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
                'Tell us more about your company to get started.',
                style: AppTextStyles.subText,
              ).animate().fadeIn(delay: 50.ms, duration: 300.ms).slideY(begin: 0.15, end: 0),
              SizedBox(height: 28.h),

              // Logo Picker
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
                            image: controller.selectedLogo.value != null
                                ? DecorationImage(
                                    image: FileImage(controller.selectedLogo.value!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: controller.selectedLogo.value == null
                              ? Icon(Icons.add_a_photo_outlined,
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

              ProfileWidgets.FieldLabel('Company Name *'),
              ProfileWidgets.FormField(
                controller: controller.companyNameController,
                hint: 'Enter company name',
              ),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('Category *'),
              SizedBox(height: 8.h),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: ExhibitorProfileController.categories.map((cat) {
                    final selected = controller.selectedCategory.value == cat;
                    return GestureDetector(
                      onTap: () => controller.selectCategory(cat),
                      child: AnimatedScale(
                        scale: selected ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primarySoft : AppColors.surface,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: selected ? AppColors.primary : AppColors.border,
                              width: selected ? 1.4 : 1,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: selected ? AppColors.primaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              Obx(() => AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: controller.isOtherCategorySelected
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12.h),
                              ProfileWidgets.FieldLabel('Specify Category *'),
                              ProfileWidgets.FormField(
                                controller: controller.customCategoryController,
                                hint: 'Type your category',
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  )),
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

              ProfileWidgets.FieldLabel('Address *'),
              ProfileWidgets.FormField(
                controller: controller.addressController,
                hint: 'Enter company address',
                maxLines: 2,
              ),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('Website (optional)'),
              ProfileWidgets.FormField(
                controller: controller.websiteController,
                hint: 'https://example.com',
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('Company Description *'),
              ProfileWidgets.FormField(
                controller: controller.descriptionController,
                hint: 'Briefly describe your business',
                maxLines: 5,
              ),
              SizedBox(height: 18.h),

              ProfileWidgets.FieldLabel('Country *'),
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    countryListTheme: CountryListThemeData(
                      backgroundColor: Colors.white,
                      bottomSheetHeight: 500.h,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      textStyle: const TextStyle(color: Colors.black),
                      searchTextStyle: const TextStyle(color: Colors.black),
                    ),
                    onSelect: controller.onCountrySelect,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            controller.selectedCountryName.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: controller.selectedCountryCode.value.isEmpty
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          )),
                      const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                    ],
                  ),
                ),
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
