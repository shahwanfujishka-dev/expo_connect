import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/visitor_qr_controller.dart';

class VisitorQrScanScreen extends GetView<VisitorQrController> {
  const VisitorQrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Mock Camera View
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Center(
              child: Container(
                width: 280.r,
                height: 280.r,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 240.w,
                        height: 2.h,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // UI Overlay
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                      Text(
                        'Save exhibitor',
                        style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 48), // Spacer for centering
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 60.h),
                  child: Column(
                    children: [
                      Text(
                        'Scan the booth\'s QR code to save it',
                        style: AppTextStyles.subText.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ModeButton(label: "QR", isSelected: true, onTap: () {}),
                          SizedBox(width: 12.w),
                          _ModeButton(label: "Card", isSelected: false, onTap: () {}),
                          SizedBox(width: 12.w),
                          _ModeButton(label: "Manual", isSelected: false, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
