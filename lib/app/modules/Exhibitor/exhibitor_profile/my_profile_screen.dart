import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/utils/app_colors.dart';
import 'controller/my_profile_controller.dart';

class MyProfileScreen extends GetView<MyProfileController> {
  const MyProfileScreen({super.key});

  void _showAvatarOptions(BuildContext context) {
    final profile = controller.profileData.value;
    final hasAvatar = profile != null && profile['avatar'] != null && (profile['avatar'] as String).isNotEmpty;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              Text("Profile Photo", style: AppTextStyles.subheading),
              SizedBox(height: 40.h, width: double.infinity),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Get.back();
                  controller.pickAndUploadAvatar();
                },
              ),
              if (hasAvatar)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  title: const Text("Remove Photo", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Get.back();
                    _confirmRemoval();
                  },
                ),
              SizedBox(height: 10.h, width: double.infinity),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _confirmRemoval() {
    Get.dialog(
      AlertDialog(
        title: const Text("Remove Photo"),
        content: const Text("Are you sure you want to remove your profile picture?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeAvatar();
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text("Edit Profile", style: AppTextStyles.subheading),
              SizedBox(height: 20.h),
              _EditField(label: "Full Name", controller: controller.nameController),
              SizedBox(height: 16.h),
              _EditField(
                label: "Email Address",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.h),
              _EditField(
                label: "Phone Number",
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 32.h),
              Obx(() => PrimaryButton(
                label: 'Save Changes',
                loading: controller.isUpdating.value,
                onPressed: controller.updateProfile,
              )),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

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
          'My Profile',
          style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _ProfileShimmer();
        }

        final profile = controller.profileData.value;
        final qr = controller.qrData.value;

        if (profile == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Profile not found"),
                TextButton(
                  onPressed: controller.fetchData,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                _ProfileHeader(
                  name: profile['name'] ?? '',
                  email: profile['email'] ?? '',
                  avatar: profile['avatar'],
                  onAvatarTap: () => _showAvatarOptions(context),
                  isUploading: controller.isUploadingAvatar.value,
                ),
                SizedBox(height: 24.h),

                if (qr != null && qr['qr_code'] != null)
                  _QrSection(qrCode: qr['qr_code']),

                SizedBox(height: 24.h),

                _DetailsSection(profile: profile),

                SizedBox(height: 32.h),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Edit Profile',
                    onPressed: () => _showEditSheet(context),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({required this.label, required this.controller, this.keyboardType});
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.background,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    this.avatar,
    required this.onAvatarTap,
    this.isUploading = false,
  });

  final String name;
  final String email;
  final String? avatar;
  final VoidCallback onAvatarTap;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : onAvatarTap,
          child: Stack(
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 4),
                  image: (avatar != null && avatar!.isNotEmpty)
                      ? DecorationImage(image: NetworkImage(avatar!), fit: BoxFit.cover)
                      : null,
                ),
                alignment: Alignment.center,
                child: (avatar == null || avatar!.isEmpty)
                    ? Text(
                        initial,
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      )
                    : null,
              ),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: AppTextStyles.heading.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          email,
          style: AppTextStyles.subText.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}

class _QrSection extends StatelessWidget {
  const _QrSection({required this.qrCode});
  final String qrCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Digital Badge',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.h),
          QrImageView(
            data: qrCode,
            version: QrVersions.auto,
            size: 180.r,
            gapless: false,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.primaryDark,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            qrCode,
            style: AppTextStyles.caption.copyWith(letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.profile});
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _DetailItem(icon: Icons.business_rounded, label: 'Company', value: profile['company'] ?? 'N/A'),
          const Divider(),
          _DetailItem(icon: Icons.badge_outlined, label: 'Designation', value: profile['designation'] ?? 'N/A'),
          const Divider(),
          _DetailItem(icon: Icons.phone_android_rounded, label: 'Phone', value: profile['phone'] ?? 'N/A'),
          const Divider(),
          _DetailItem(icon: Icons.chat_outlined, label: 'WhatsApp', value: profile['whatsapp'] ?? 'N/A'),
          const Divider(),
          _DetailItem(icon: Icons.person_outline_rounded, label: 'User Type', value: (profile['user_type'] as String?)?.capitalizeFirst ?? 'N/A'),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          children: [
            Container(width: 100.r, height: 100.r, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            SizedBox(height: 16.h),
            Container(width: 150.w, height: 24.h, color: Colors.white),
            SizedBox(height: 8.h),
            Container(width: 200.w, height: 16.h, color: Colors.white),
            SizedBox(height: 24.h),
            Container(width: double.infinity, height: 250.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r))),
            SizedBox(height: 24.h),
            Container(width: double.infinity, height: 300.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r))),
          ],
        ),
      ),
    );
  }
}
