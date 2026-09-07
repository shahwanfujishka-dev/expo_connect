import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/visitor_brochures_controller.dart';

class VisitorBrochuresScreen extends GetView<VisitorBrochuresController> {
  const VisitorBrochuresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Brochures & documents', style: AppTextStyles.subheading),
      ),
      body: Obx(() => ListView.separated(
            padding: EdgeInsets.all(20.r),
            itemCount: controller.brochures.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final brochure = controller.brochures[index];
              return _BrochureTile(
                brochure: brochure,
                onDownload: () => controller.downloadBrochure(brochure),
              );
            },
          )),
    );
  }
}

class _BrochureTile extends StatelessWidget {
  const _BrochureTile({required this.brochure, required this.onDownload});
  final BrochureModel brochure;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (brochure.type) {
      case 'pdf':
        iconData = Icons.picture_as_pdf_outlined;
        break;
      case 'video':
        iconData = Icons.play_circle_outline;
        break;
      case 'image':
        iconData = Icons.image_outlined;
        break;
      default:
        iconData = Icons.description_outlined;
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(iconData, color: AppColors.primary, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brochure.title,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  brochure.size,
                  style: AppTextStyles.subText,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined, color: AppColors.textSecondary),
            onPressed: onDownload,
          ),
        ],
      ),
    );
  }
}
