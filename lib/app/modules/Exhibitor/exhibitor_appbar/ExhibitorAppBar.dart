import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_colors.dart';

/// Shared top bar for every Exhibitor screen.
class ExhibitorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExhibitorAppBar({
    super.key,
    required this.onMenuTap,
    this.onNotificationTap,
    this.onAvatarTap,
    this.showNotificationDot = false,
  });

  final VoidCallback onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;
  final bool showNotificationDot;

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leadingWidth: 68.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: _SquareIconButton(icon: Icons.menu_rounded, onTap: onMenuTap),
      ),
      actions: [
        _SquareIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap ?? () {},
          showDot: showNotificationDot,
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: onAvatarTap ?? onMenuTap,
          child: CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.primarySoft,
            child: Icon(Icons.person_rounded, size: 18.sp, color: AppColors.primaryDark),
          ),
        ),
        SizedBox(width: 20.w),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, required this.onTap, this.showDot = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 20.sp, color: AppColors.textPrimary),
              if (showDot)
                Positioned(
                  top: 8.h,
                  right: 9.w,
                  child: Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
