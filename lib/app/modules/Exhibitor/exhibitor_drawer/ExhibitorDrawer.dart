import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import '../../../routes/app_routes.dart';

class ExhibitorDrawer extends StatelessWidget {
  const ExhibitorDrawer({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.companyName,
    required this.onLogout,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final String companyName;
  final VoidCallback onLogout;

  static double get _width => 300.w;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Scrim(isOpen: isOpen, onTap: onClose),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          top: 0,
          bottom: 0,
          left: isOpen ? 0 : -_width - 20.w,
          width: _width,
          child: Material(
            elevation: 20,
            color: AppColors.surface,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(26.r)),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DrawerHeader(companyName: companyName, onClose: onClose),
                  Divider(height: 1.h, color: AppColors.border),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(12.w, 18.h, 12.w, 18.h),
                      children: [
                        const _SectionLabel('WORKSPACE'),
                        SizedBox(height: 8.h),
                        _DrawerTile(
                          icon: Icons.dashboard_rounded,
                          label: 'Dashboard',
                          selected: true,
                          onTap: onClose,
                        ),
                        _DrawerTile(
                          icon: Icons.leaderboard_rounded,
                          label: 'Lead pipeline',
                          onTap: () {
                            onClose();
                            // Get.toNamed(Routes.LEAD_PIPELINE);
                          },
                        ),
                        _DrawerTile(
                          icon: Icons.groups_rounded,
                          label: 'Team',
                          onTap: () {
                            onClose();
                            // Get.toNamed(Routes.TEAM);
                          },
                        ),
                        SizedBox(height: 20.h),
                        const _SectionLabel('INSIGHTS'),
                        SizedBox(height: 8.h),
                        _DrawerTile(
                          icon: Icons.insert_chart_rounded,
                          label: 'Analytics',
                          onTap: () {
                            onClose();
                            // Get.toNamed(Routes.ANALYTICS);
                          },
                        ),
                        SizedBox(height: 20.h),
                        const _SectionLabel('ACCOUNT'),
                        SizedBox(height: 8.h),
                        _DrawerTile(
                          icon: Icons.storefront_rounded,
                          label: 'Company profile',
                          onTap: () {
                            onClose();
                            Get.toNamed(Routes.EXHIBITOR_PROFILE);
                          },
                        ),
                        _DrawerTile(
                          icon: Icons.settings_outlined,
                          label: 'Settings',
                          onTap: () {
                            onClose();
                            // Get.toNamed(Routes.SETTINGS);
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1.h, color: AppColors.border),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
                    child: Column(
                      children: [
                        _DrawerTile(
                          icon: Icons.logout_rounded,
                          label: 'Log out',
                          color: AppColors.error,
                          onTap: () {
                            onClose();
                            onLogout();
                          },
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Exhibitor Portal',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Scrim extends StatelessWidget {
  const _Scrim({required this.isOpen, required this.onTap});
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isOpen,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            opacity: isOpen ? 1 : 0,
            child: Container(color: Colors.black.withOpacity(0.42)),
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.companyName, required this.onClose});

  final String companyName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final initial =
    companyName.trim().isNotEmpty ? companyName.trim()[0].toUpperCase() : 'E';

    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 12.w, 18.h),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.20),
                  blurRadius: 14.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: TextStyle(color: Colors.white, fontSize: 19.sp, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName.isEmpty ? 'Your Company' : companyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'EXHIBITOR',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _RoundIconButton(icon: Icons.close_rounded, onTap: onClose),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? (selected ? AppColors.primaryDark : AppColors.textPrimary);

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Material(
        color: selected ? AppColors.primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(13.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(13.r),
          onTap: onTap,
          child: SizedBox(
            height: 48.h,
            child: Row(
              children: [
                SizedBox(width: selected ? 9.w : 12.w),
                if (selected)
                  Container(
                    width: 3.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                SizedBox(width: selected ? 9.w : 0),
                Icon(icon, size: 20.sp, color: fg),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ),
                if (selected)
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Icon(Icons.chevron_right_rounded, size: 19.sp, color: AppColors.primaryDark),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: SizedBox(
          width: 36.w,
          height: 36.w,
          child: Icon(icon, size: 19.sp, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
