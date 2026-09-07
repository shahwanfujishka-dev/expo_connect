import 'package:expo_connect/app/modules/roleSelection/widgets/Role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/utils/app_colors.dart';
import 'controller/role_controller.dart';

class RoleSelectionScreen extends GetView<RoleController> {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48.h),
              Text('I\'m attending as...', style: AppTextStyles.heading),
              SizedBox(height: 8.h),
              Text(
                'This decides which tools show up on your home screen.',
                style: AppTextStyles.subText,
              ),
              SizedBox(height: 28.h),
              Obx(
                () => RoleCard(
                  title: 'Exhibitor',
                  subtitle: 'Capture and manage visitor leads',
                  icon: Icons.storefront_rounded,
                  selected: controller.selectedRole.value == AttendeeRole.exhibitor,
                  onTap: () => controller.select(AttendeeRole.exhibitor),
                ),
              ),
              SizedBox(height: 14.h),
              Obx(
                () => RoleCard(
                  title: 'Visitor',
                  subtitle: 'Discover exhibitors and plan my visit',
                  icon: Icons.explore_rounded,
                  selected: controller.selectedRole.value == AttendeeRole.visitor,
                  onTap: () => controller.select(AttendeeRole.visitor),
                ),
              ),
              const Spacer(),
              Obx(
                () => PrimaryButton(
                  label: 'Continue',
                  enabled: controller.selectedRole.value != null,
                  loading: controller.isLoading.value,
                  onPressed: controller.continueTapped,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
