import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/visitor_discover_controller.dart';

class VisitorFilterScreen extends GetView<VisitorDiscoverController> {
  const VisitorFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Filters', style: AppTextStyles.subheading),
        actions: [
          TextButton(
            onPressed: () {
              controller.selectedCategory.value = "All";
              Get.back();
            },
            child: Text(
              'Reset',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterSection(
              title: 'CATEGORY',
              children: controller.categories.map((cat) => _FilterChip(label: cat, type: 'category')).toList(),
            ),
            SizedBox(height: 24.h),
            _FilterSection(
              title: 'HALL',
              children: [
                _FilterChip(label: 'Hall 1', type: 'hall'),
                _FilterChip(label: 'Hall 2', type: 'hall'),
                _FilterChip(label: 'Hall 3', type: 'hall'),
              ],
            ),
            SizedBox(height: 24.h),
            _FilterSection(
              title: 'BOOTH STATUS',
              children: [
                _FilterChip(label: 'Visited', type: 'status'),
                _FilterChip(label: 'Not Visited', type: 'status'),
              ],
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Show 18 results',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: children,
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.type});
  final String label;
  final String type;

  @override
  Widget build(BuildContext context) {
    // Note: For now just visual mock, logic would tie back to controller
    bool isSelected = label == "All"; 
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySoft : AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
