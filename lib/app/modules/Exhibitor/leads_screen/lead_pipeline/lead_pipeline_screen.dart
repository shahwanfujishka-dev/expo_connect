import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/lead.dart';
import '../../../../routes/app_routes.dart';
import '../../exhibitor_appbar/ExhibitorAppBar.dart';
import '../../ExhibitorNav/ExhibitorNavController.dart';
import 'controller/lead_pipeline_controller.dart';

class LeadPipelineScreen extends GetView<LeadPipelineController> {
  const LeadPipelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<ExhibitorNavController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ExhibitorAppBar(
        onMenuTap: navCtrl.toggleDrawer,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Text('Lead pipeline', style: AppTextStyles.heading),
            ),
            _buildFilterRow(),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.allLeads.isEmpty) {
                  return const _LeadsShimmer();
                }
                
                if (controller.filteredLeads.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.fetchLeads,
                    child: ListView(
                      children: [
                        SizedBox(height: 100.h),
                        const Center(child: Text("No leads found")),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.fetchLeads,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                    itemCount: controller.filteredLeads.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return _LeadPipelineTile(lead: controller.filteredLeads[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            _buildFilterItem(
              label: 'All',
              isSelected: controller.selectedStatusId.value == null,
              count: controller.getStatusCount(null),
              onTap: () => controller.filterByStatus(null),
            ),
            ...controller.statuses.map((status) {
              return _buildFilterItem(
                label: status.name,
                isSelected: controller.selectedStatusId.value == status.id,
                count: controller.getStatusCount(status.id),
                onTap: () => controller.filterByStatus(status.id),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildFilterItem({
    required String label,
    required bool isSelected,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.w,
          ),
        ),
        child: Text(
          '$label $count',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _LeadsShimmer extends StatelessWidget {
  const _LeadsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        itemCount: 6,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}

class _LeadPipelineTile extends StatelessWidget {
  const _LeadPipelineTile({required this.lead});
  final Lead lead;

  Color _getStatusColor() {
    if (lead.status_color != null && lead.status_color!.isNotEmpty) {
      try {
        return Color(int.parse(lead.status_color!.replaceFirst('#', '0xff')));
      } catch (e) {
        // Fallback
      }
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final initials = lead.name.isNotEmpty 
        ? lead.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : '?';
    
    final String statusLabel = lead.status_name.isNotEmpty 
        ? lead.status_name 
        : 'New';

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.LEAD_DETAILS, arguments: lead),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.primarySoft,
              child: Text(
                initials,
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lead.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 2.h),
                  Text(lead.company, style: AppTextStyles.subText),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
