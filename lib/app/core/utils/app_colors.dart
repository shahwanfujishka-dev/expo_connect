import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Central palette for Expo Connect
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1D8A4C);
  static const Color primaryDark = Color(0xFF146238);
  static const Color primarySoft = Color(0xFFEAF7EF);

  static const Color background = Color(0xFFF7FAF8);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF13231A);
  static const Color textSecondary = Color(0xFF6B7A72);
  static const Color border = Color(0xFFE1E8E3);
  static const Color error = Color(0xFFD8433A);
}

/// Central Typography class using ScreenUtil for responsive font sizes
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heading => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get subheading => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get subText => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get caption => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

/// Reusable responsive Primary Button
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: loading
          ? Shimmer.fromColors(
              baseColor: AppColors.primary.withOpacity(0.6),
              highlightColor: AppColors.primary.withOpacity(0.3),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: enabled ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(label, style: AppTextStyles.button),
            ),
    );
  }
}
