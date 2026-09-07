import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/exhibitor_details_controller.dart';

class VisitorExhibitorDetailsScreen extends GetView<VisitorExhibitorDetailsController> {
  const VisitorExhibitorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: Center(
                  child: Text(
                    controller.exhibitor.initials,
                    style: TextStyle(
                      fontSize: 60.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Obx(() => IconButton(
                    icon: Icon(
                      controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: controller.toggleFavorite,
                  )),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.exhibitor.name, style: AppTextStyles.heading),
                          SizedBox(height: 4.h),
                          Text(
                            "${controller.exhibitor.hall} • ${controller.exhibitor.booth}",
                            style: AppTextStyles.subheading.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          controller.exhibitor.category,
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.map_outlined),
                          label: const Text("Locate"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.downloadBrochure,
                          icon: const Icon(Icons.description_outlined),
                          label: const Text("Brochure"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text("About", style: AppTextStyles.subheading),
                  SizedBox(height: 8.h),
                  Text(
                    controller.exhibitor.description ??
                        "Interested in multi-layer printing for organic cotton line. Asked for a sample kit.",
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, height: 1.5),
                  ),
                  SizedBox(height: 32.h),
                  PrimaryButton(
                    label: "Add to my plan",
                    onPressed: controller.saveExhibitor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
