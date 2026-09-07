import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/lead.dart';
import 'controller/lead_details_controller.dart';

class LeadDetailsScreen extends GetView<LeadDetailsController> {
  const LeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value && controller.detailedLead.value == null) {
          return const _LeadDetailsShimmer();
        }

        final lead = controller.detailedLead.value ?? controller.lead;
        final initials = lead.name.isNotEmpty
            ? lead.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
            : '?';
        final tempColor = _getTemperatureColor(lead.temperature);

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              pinned: true,
              expandedHeight: 190.h,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primarySoft.withOpacity(0.6),
                        AppColors.background,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 20.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.background,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 34.r,
                          backgroundColor: AppColors.primarySoft,
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lead.name,
                              style: AppTextStyles.heading.copyWith(fontSize: 20.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${lead.title}, ${lead.company}',
                              style: AppTextStyles.subText.copyWith(fontSize: 13.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            _Tag(label: '${lead.temperature.label} lead', color: tempColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Call',
                          icon: Icons.call_rounded,
                          onPressed: controller.callLead,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _ActionButton(
                          label: 'WhatsApp',
                          icon: Icons.chat_bubble_rounded,
                          onPressed: controller.whatsappLead,
                          color: const Color(0xFF25D366),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _ActionButton(
                          label: 'Email',
                          icon: Icons.email_rounded,
                          onPressed: controller.emailLead,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // Contact Details Section
                  _SectionCard(
                    title: 'Contact details',
                    child: Column(
                      children: [
                        if (lead.email != null)
                          _InfoRow(icon: Icons.email_outlined, text: lead.email!, color: AppColors.primaryDark),
                        if (lead.phone != null)
                          _InfoRow(icon: Icons.phone_outlined, text: lead.phone!, color: AppColors.primaryDark),
                        if (lead.whatsapp != null)
                          _InfoRow(icon: Icons.chat_outlined, text: lead.whatsapp!, color: const Color(0xFF25D366), isLast: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Notes Section
                  _SectionCard(
                    title: 'Notes',
                    trailing: Icon(Icons.edit_outlined, size: 18.sp, color: AppColors.textSecondary),
                    child: Text(
                      controller.notesController.text.isEmpty ? 'No notes added yet.' : controller.notesController.text,
                      style: AppTextStyles.body.copyWith(
                        height: 1.6,
                        color: controller.notesController.text.isEmpty ? AppColors.textSecondary : AppColors.textPrimary,
                        fontStyle: controller.notesController.text.isEmpty ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Color _getTemperatureColor(LeadTemperature temperature) {
    switch (temperature) {
      case LeadTemperature.hot: return AppColors.error;
      case LeadTemperature.warm: return const Color(0xFFB98A1E);
      case LeadTemperature.cold: return AppColors.textSecondary;
      case LeadTemperature.newLead: return AppColors.primary;
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }
}

class _LeadDetailsShimmer extends StatelessWidget {
  const _LeadDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 70.r,
                  height: 70.r,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150.w, height: 20.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                      SizedBox(height: 8.h),
                      Container(width: 100.w, height: 14.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                      SizedBox(height: 10.h),
                      Container(width: 80.w, height: 22.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r))),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            Row(
              children: List.generate(3, (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 2 ? 0 : 12.w),
                  height: 60.h,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
                ),
              )),
            ),
            SizedBox(height: 20.h),
            Container(width: double.infinity, height: 140.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18.r))),
            SizedBox(height: 16.h),
            Container(width: double.infinity, height: 100.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18.r))),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text, required this.color, this.isLast = false});
  final IconData icon;
  final String text;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(fontSize: 14.5.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            children: [
              Icon(icon, size: 20.sp, color: color),
              SizedBox(height: 6.h),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}