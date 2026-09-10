import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_colors.dart';

class VisitorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VisitorAppBar({
    super.key,
    required this.title,
    this.onMenuTap,
  });

  final String title;
  final VoidCallback? onMenuTap;

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 20.w,
      title: Row(
        children: [
          _SquareIconButton(
            icon: Icons.menu_rounded,
            onTap: onMenuTap ??
                    () {
                  Scaffold.of(context).openDrawer();
                },
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: AppTextStyles.heading,
          ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border, width: 1.w),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.primary),
        ),
      ),
    );
  }
}
