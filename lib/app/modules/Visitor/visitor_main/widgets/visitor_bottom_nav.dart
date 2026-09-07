import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';

class VisitorNavItem {
  const VisitorNavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

const visitorNavItems = [
  VisitorNavItem(Icons.explore_outlined, 'Discover'),
  VisitorNavItem(Icons.event_note_outlined, 'Plan'),
  VisitorNavItem(Icons.qr_code_scanner_rounded, 'Scan'),
  VisitorNavItem(Icons.contact_phone_outlined, 'Contacts'),
  VisitorNavItem(Icons.account_circle_outlined, 'Profile'),
];

class VisitorBottomNav extends StatelessWidget {
  const VisitorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72.h,
          child: Row(
            children: List.generate(
              visitorNavItems.length,
              (index) => Expanded(
                child: _NavItem(
                  item: visitorNavItems[index],
                  selected: currentIndex == index,
                  isScan: index == 2,
                  onTap: () => onTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.isScan,
    required this.onTap,
  });

  final VisitorNavItem item;
  final bool selected;
  final bool isScan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isScan) {
      return _ScanButton(onTap: onTap);
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(top: 7.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.08 : 1,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              child: Icon(
                item.icon,
                size: 23.sp,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 5.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.caption.copyWith(
                fontSize: 11.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              child: Text(item.label),
            ),
            SizedBox(height: 4.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: selected ? 20.w : 0,
              height: 3.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: Offset(0, -10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54.r,
              height: 54.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.30),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 27.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Scan',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
