import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/models/lead.dart';
import '../ExhibitorNav/ExhibitorNavController.dart';
import '../exhibitor_appbar/ExhibitorAppBar.dart';
import 'controller/dashBoard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<ExhibitorNavController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ExhibitorAppBar(
        onMenuTap: navCtrl.toggleDrawer,
        showNotificationDot: true,
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          final stats = controller.stats.value!;
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.loadDashboard,
            child: ListView(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
              children: [
                Text('Good morning', style: AppTextStyles.subText),
                Text(controller.companyName.value, style: AppTextStyles.heading),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(label: 'Leads today', value: '${stats.leadsToday}'),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _StatCard(label: 'Hot leads', value: '${stats.hotLeads}'),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _StatCard(
                        label: 'Conversion',
                        value: '${stats.conversionPercent}%',
                        highlighted: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _ActionChip(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan QR',
                        filled: true,
                        onTap: controller.scanQrTapped,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _ActionChip(
                        icon: Icons.badge_outlined,
                        label: 'Scan card',
                        onTap: controller.scanCardTapped,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _ActionChip(
                        icon: Icons.edit_note_rounded,
                        label: 'Manual',
                        dark: true,
                        onTap: controller.manualEntryTapped,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent leads', style: AppTextStyles.body),
                    GestureDetector(
                      onTap: () {
                        navCtrl.changePage(1);
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                if (controller.recentLeads.isEmpty)
                  const _EmptyRecentLeads()
                else
                  ...controller.recentLeads.map((lead) => _LeadTile(lead: lead)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, this.highlighted = false});

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: highlighted ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: highlighted ? Colors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: highlighted ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.dark = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg = dark
        ? AppColors.textPrimary
        : (filled ? AppColors.primary : AppColors.surface);
    final fg = (dark || filled) ? Colors.white : AppColors.textPrimary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: (!dark && !filled) ? Border.all(color: AppColors.border) : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: fg, size: 20.sp),
              SizedBox(height: 6.h),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadTile extends StatelessWidget {
  const _LeadTile({required this.lead});
  final Lead lead;

  Color _tagColor() {
    switch (lead.temperature) {
      case LeadTemperature.hot:
        return AppColors.error;
      case LeadTemperature.warm:
        return const Color(0xFFB98A1E);
      case LeadTemperature.cold:
        return AppColors.textSecondary;
      case LeadTemperature.newLead:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagColor = _tagColor();

    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              lead.name.isNotEmpty ? lead.name[0] : '?',
              style: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        lead.name,
                        style: AppTextStyles.body.copyWith(fontSize: 14.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (lead.pendingSync) ...[
                      SizedBox(width: 6.w),
                      Icon(Icons.sync, size: 13.sp, color: AppColors.textSecondary),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  lead.title,
                  style: AppTextStyles.subText,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              lead.temperature.label,
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: tagColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyRecentLeads extends StatelessWidget {
  const _EmptyRecentLeads();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.badge_outlined, color: AppColors.textSecondary, size: 28.sp),
          SizedBox(height: 10.h),
          Text('No leads captured yet', style: AppTextStyles.body),
          SizedBox(height: 4.h),
          Text(
            'Scan a badge or business card to get started.',
            style: AppTextStyles.subText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}