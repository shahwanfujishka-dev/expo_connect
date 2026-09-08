import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/lead.dart';
import 'controller/lead_details_controller.dart';
import 'widgets/lead_details_widgets.dart';
import 'widgets/lead_tab_views.dart';

class LeadDetailsScreen extends GetView<LeadDetailsController> {
  const LeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value && controller.detailedLead.value == null) {
          return const LeadDetailsShimmer();
        }

        final lead = controller.detailedLead.value ?? controller.lead;
        final initials = lead.name.isNotEmpty
            ? lead.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
            : '?';
        final tempColor = _getTemperatureColor(lead.temperature);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(lead, initials, tempColor),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildQuickActions(),
                  SizedBox(height: 24.h),
                  _buildContactSection(lead),
                  SizedBox(height: 28.h),
                  _buildInteractionTabs(),
                  SizedBox(height: 20.h),
                  _buildTabContent(),
                  SizedBox(height: 40.h),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(Lead lead, String initials, Color tempColor) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      pinned: true,
      expandedHeight: 200.h,
      stretch: true,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18.sp),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primarySoft.withOpacity(0.6),
                AppColors.background,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20.w,
                top: -20.h,
                child: CircleAvatar(
                  radius: 80.r,
                  backgroundColor: AppColors.primary.withOpacity(0.05),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 20.h),
                child: Row(
                  children: [
                    Hero(
                      tag: 'lead_avatar_${lead.id}',
                      child: Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 36.r,
                          backgroundColor: AppColors.surface,
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lead.name,
                            style: AppTextStyles.heading.copyWith(fontSize: 20.sp, letterSpacing: -0.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.business_center_outlined, size: 14.sp, color: AppColors.textSecondary),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  '${lead.title} @ ${lead.company}',
                                  style: AppTextStyles.subText.copyWith(fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          TemperatureTag(label: '${lead.temperature.label} lead', color: tempColor),
                        ],
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
            child: QuickActionBtn(
                icon: Icons.call_rounded,
                label: 'Call',
                color: AppColors.primary,
                onTap: controller.callLead)),
        SizedBox(width: 12.w),
        Expanded(
            child: QuickActionBtn(
                icon: Icons.chat_bubble_rounded,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: controller.whatsappLead)),
        SizedBox(width: 12.w),
        Expanded(
            child: QuickActionBtn(
                icon: Icons.email_rounded,
                label: 'Email',
                color: const Color(0xFFEA4335),
                onTap: controller.emailLead)),
      ],
    ).animate().fadeIn(delay: 200.ms).moveY(begin: 20);
  }

  Widget _buildContactSection(Lead lead) {
    return SectionCard(
      title: 'Contact details',
      child: Column(
        children: [
          if (lead.email != null)
            InfoRow(icon: Icons.email_outlined, text: lead.email!, color: AppColors.primaryDark),
          if (lead.phone != null)
            InfoRow(icon: Icons.phone_outlined, text: lead.phone!, color: AppColors.primaryDark),
          if (lead.whatsapp != null)
            InfoRow(
                icon: Icons.chat_outlined,
                text: lead.whatsapp!,
                color: const Color(0xFF25D366),
                isLast: true),
        ],
      ),
    );
  }

  Widget _buildInteractionTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LEAD INTERACTION',
            style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.textSecondary,
                letterSpacing: 1.2)),
        SizedBox(height: 14.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(controller.tabs.length, (index) {
              return Obx(() {
                final isSelected = controller.selectedTabIndex.value == index;
                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AnimatedContainer(
                    duration: 250.ms,
                    child: ChoiceChip(
                      label: Text(controller.tabs[index]),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) controller.selectedTabIndex.value = index;
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      showCheckmark: false,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                );
              });
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return Obx(() => AnimatedSwitcher(
          duration: 350.ms,
          switchInCurve: Curves.easeOutQuart,
          switchOutCurve: Curves.easeInQuart,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                    .animate(animation),
                child: child,
              ),
            );
          },
          child: _getSelectedTabWidget(),
        ));
  }

  Widget _getSelectedTabWidget() {
    switch (controller.selectedTabIndex.value) {
      case 0:
        return const NoteTabView(key: ValueKey('note_tab'));
      case 1:
        return const TagsProductsTabView(key: ValueKey('tags_tab'));
      case 2:
        return const FollowUpTabView(key: ValueKey('followup_tab'));
      case 3:
        return const DocumentsTabView(key: ValueKey('docs_tab'));
      default:
        return const SizedBox.shrink();
    }
  }

  Color _getTemperatureColor(LeadTemperature temperature) {
    switch (temperature) {
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
}
