import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/utils/app_colors.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: controller.animController,
              builder: (context, child) => Transform.scale(
                scale: controller.logoScale.value,
                child: Opacity(
                  opacity: controller.logoFade.value,
                  child: child,
                ),
              ),
              child: Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 24.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'FK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            AnimatedBuilder(
              animation: controller.animController,
              builder: (context, child) => SlideTransition(
                position: controller.textSlide,
                child: FadeTransition(
                  opacity: controller.textFade,
                  child: child,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Expo Connect',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Capture leads. Follow up faster.',
                    style: AppTextStyles.subText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
