import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/brochure_controller.dart';

class AddBrochureScreen extends GetView<BrochureController> {
  const AddBrochureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Brochure'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brochure Details',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: controller.titleController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter brochure title',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Upload File (Image or PDF)',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 12.h),
            Obx(() => GestureDetector(
                  onTap: () => controller.pickFile(),
                  child: Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: controller.selectedFile.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_present_rounded,
                                  size: 48.sp, color: AppColors.textSecondary),
                              SizedBox(height: 8.h),
                              Text('Tap to select a file',
                                  style: AppTextStyles.caption),
                              Text('(Supports JPG, PNG, PDF)',
                                  style: AppTextStyles.caption.copyWith(fontSize: 10.sp)),
                            ],
                          )
                        : controller.fileType.value == 'image'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(
                                  controller.selectedFile.value!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.picture_as_pdf_rounded,
                                      size: 64.sp, color: Colors.redAccent),
                                  SizedBox(height: 8.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      controller.selectedFile.value!.path.split('/').last,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text('PDF File Selected',
                                      style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                                ],
                              ),
                  ),
                )),
            SizedBox(height: 40.h),
            Obx(() => PrimaryButton(
                  label: 'Upload Brochure',
                  onPressed: () => controller.uploadBrochure(),
                  loading: controller.isAdding.value,
                )),
          ],
        ),
      ),
    );
  }
}
