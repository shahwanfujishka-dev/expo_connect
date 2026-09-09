import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/services/endpoints.dart';
import '../controller/sales_person_details_controller.dart';

class SalesPersonDetailsScreen extends GetView<SalesPersonDetailsController> {
  const SalesPersonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Member Details',
          style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value, style: AppTextStyles.body),
          );
        }

        final member = controller.salesPerson.value;
        if (member == null) {
          return const Center(child: Text("Member not found"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              // Profile Header
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                  image: member.avatar != null
                      ? DecorationImage(
                          image: NetworkImage(Endpoints.baseUrl + '/public/storage/' + member.avatar!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                alignment: Alignment.center,
                child: member.avatar == null
                    ? Text(
                        (member.name ?? member.user?.name ?? '?')[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      )
                    : null,
              ),
              SizedBox(height: 16.h),
              Text(
                member.name ?? member.user?.name ?? 'Unknown',
                style: AppTextStyles.heading.copyWith(fontSize: 22.sp),
              ),
              Text(
                member.role.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 32.h),

              // Info Cards
              _InfoTile(
                icon: Icons.business_rounded,
                label: 'Company',
                value: member.companyName ?? 'N/A',
              ),
              SizedBox(height: 12.h),
              _InfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: member.email ?? 'N/A',
              ),
              SizedBox(height: 12.h),
              _InfoTile(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: member.phone ?? 'N/A',
              ),

              SizedBox(height: 32.h),

              // Statistics
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Leads',
                      value: member.totalLeadsCount.toString(),
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      label: 'Captured',
                      value: member.capturedCount.toString(),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Assigned',
                      value: member.assignedCount.toString(),
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      label: 'Converted',
                      value: (member.convertedCount ?? 0).toString(),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22.sp),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.heading.copyWith(color: color, fontSize: 24.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
