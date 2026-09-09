import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/exhibitor_details_controller.dart';

class VisitorExhibitorDetailsScreen extends GetView<VisitorExhibitorDetailsController> {
  const VisitorExhibitorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value && controller.companyDetails.isEmpty) {
          return const _ExhibitorDetailsShimmer();
        }

        final company = controller.companyDetails;
        final name = company['name'] ?? controller.initialExhibitor.name;
        final hall = company['hall'] ?? controller.initialExhibitor.hall;
        final stall = company['stall'] ?? controller.initialExhibitor.booth;
        final category = company['category'] ?? controller.initialExhibitor.category;
        final description = company['description'] ?? controller.initialExhibitor.description;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 240.h,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryDark,
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 120.r,
                        height: 120.r,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: controller.logoUrl.isNotEmpty
                              ? Image.network(
                                  controller.logoUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildInitial(controller.initialExhibitor.initials),
                                )
                              : _buildInitial(controller.initialExhibitor.initials),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Obx(() => IconButton(
                      icon: Icon(
                        controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                        color: controller.isFavorite.value ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: controller.toggleFavorite,
                    )),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: AppTextStyles.heading.copyWith(fontSize: 22.sp)),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16.sp, color: AppColors.primary),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "$hall • Stall $stall",
                                    style: AppTextStyles.subheading.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),

                    // Action Buttons
                    Row(
                      children: [
                        _DetailActionButton(
                          icon: Icons.public,
                          label: "Website",
                          onPressed: () {}, // TODO: Launch website
                        ),
                        SizedBox(width: 12.w),
                        _DetailActionButton(
                          icon: Icons.file_download_outlined,
                          label: "Brochure",
                          onPressed: controller.downloadBrochure,
                        ),
                        SizedBox(width: 12.w),
                        _DetailActionButton(
                          icon: Icons.share_outlined,
                          label: "Share",
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // About
                    if (description != null && description.isNotEmpty) ...[
                      Text("About Company", style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.w700)),
                      SizedBox(height: 12.h),
                      Text(
                        description,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],

                    // Contact Section
                    Text("Contact Details", style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(height: 16.h),
                    _ContactCard(
                      icon: Icons.email_outlined,
                      title: "Email",
                      value: company['email'] ?? "Not available",
                    ),
                    _ContactCard(
                      icon: Icons.phone_outlined,
                      title: "Phone",
                      value: company['phone'] ?? "Not available",
                    ),
                    _ContactCard(
                      icon: Icons.phone_rounded,
                      title: "WhatsApp",
                      value: company['whatsapp'] ?? "Not available",
                    ),
                    _ContactCard(
                      icon: Icons.map_outlined,
                      title: "Address",
                      value: company['address'] ?? "Not available",
                    ),

                    SizedBox(height: 40.h),
                    PrimaryButton(
                      label: "Add to My Plan",
                      onPressed: controller.saveExhibitor,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInitial(String initials) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 48.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
    );
  }
}

class _DetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _DetailActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Icon(icon, size: 22.sp, color: AppColors.primary),
                SizedBox(height: 6.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ContactCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.sp, color: AppColors.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExhibitorDetailsShimmer extends StatelessWidget {
  const _ExhibitorDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Column(
        children: [
          Container(height: 240.h, color: Colors.white),
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 180.w, height: 24.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(width: 120.w, height: 16.h, color: Colors.white),
                      ],
                    ),
                    Container(width: 70.w, height: 28.h, color: Colors.white),
                  ],
                ),
                SizedBox(height: 32.h),
                Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        height: 60.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Container(width: 100.w, height: 20.h, color: Colors.white),
                SizedBox(height: 12.h),
                Container(width: double.infinity, height: 100.h, color: Colors.white),
                SizedBox(height: 32.h),
                ...List.generate(
                  3,
                  (index) => Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    height: 70.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
