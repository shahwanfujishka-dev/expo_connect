import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/services/endpoints.dart';
import '../controller/brochure_controller.dart';

class BrochureScreen extends GetView<BrochureController> {
  const BrochureScreen({super.key});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime dateTime = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Brochures'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.fetchBrochures(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Obx(() {
        // Show shimmer during initial load or when list is empty and loading
        if (controller.isLoading.value && controller.brochures.isEmpty) {
          return _buildShimmerList();
        }

        if (controller.brochures.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined,
                    size: 64.sp,
                    color: AppColors.textSecondary.withOpacity(0.5)),
                SizedBox(height: 16.h),
                Text(
                  'No brochures added yet',
                  style:
                      TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => controller.fetchBrochures(),
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.brochures.length,
                itemBuilder: (context, index) {
                  final brochure = controller.brochures[index];
                  
                  // Per-item shimmer for deletion
                  if (controller.deletingId.value == brochure.id) {
                    return _buildSingleShimmer();
                  }

                  final imageUrl = brochure.filePath != null
                      ? '${Endpoints.baseUrl}/public/storage/${brochure.filePath}'
                      : null;

                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    color: AppColors.surface,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(12.r),
                              image: brochure.fileType == 'image' &&
                                      imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: brochure.fileType != 'image' || imageUrl == null
                                ? Icon(
                                    brochure.fileType == 'image'
                                        ? Icons.image
                                        : Icons.picture_as_pdf,
                                    color: AppColors.primary,
                                    size: 28.sp,
                                  )
                                : null,
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  brochure.title,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _formatDate(brochure.createdAt),
                                  style: AppTextStyles.caption
                                      .copyWith(fontSize: 11.sp),
                                ),
                                if (brochure.savedByVisitorsCount != null &&
                                    brochure.savedByVisitorsCount! > 0) ...[
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Icon(Icons.bookmark_added_rounded,
                                          size: 14.sp, color: AppColors.primary),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Saved by ${brochure.savedByVisitorsCount} visitor(s)',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline_rounded,
                                color: AppColors.error, size: 22.sp),
                            onPressed: () {
                              if (brochure.id != null) {
                                controller.deleteBrochure(brochure.id!);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Show shimmer overlay ONLY during general refresh/initial load, not during per-item deletion
            if (controller.isLoading.value && controller.brochures.isNotEmpty && controller.deletingId.value == null)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.3),
                  child: _buildShimmerList(),
                ),
              ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.goToAddBrochure(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSingleShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        height: 84.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildSingleShimmer();
      },
    );
  }
}
