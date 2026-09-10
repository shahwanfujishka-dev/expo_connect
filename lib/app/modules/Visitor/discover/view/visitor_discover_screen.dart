import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../routes/app_routes.dart';
import '../../visitor_appbar/VisitorAppBar.dart';
import '../../visitor_main/controller/visitor_main_controller.dart';
import '../controller/visitor_discover_controller.dart';

class VisitorDiscoverScreen extends GetView<VisitorDiscoverController> {
  const VisitorDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<VisitorMainController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VisitorAppBar(
        title: 'Discover exhibitors',
        onMenuTap: mainController.toggleDrawer,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatsOverview(),
                SizedBox(height: 16.h),
                _SearchBar(onChanged: controller.onSearch),
                SizedBox(height: 16.h),
                _CategoryFilters(),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.exhibitors.isEmpty) {
                return _LoadingShimmer();
              }

              final list = controller.filteredExhibitors;
              if (list.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.fetchDashboard,
                  child: ListView(
                    children: [
                      SizedBox(height: 100.h),
                      const Center(child: Text("No exhibitors found")),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchDashboard,
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final exhibitor = list[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        Routes.VISITOR_EXHIBITOR_DETAILS,
                        arguments: exhibitor,
                      ),
                      child: _ExhibitorCard(
                        exhibitor: exhibitor,
                        onFavoriteTap: () => controller.toggleFavorite(exhibitor),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StatsOverview extends GetView<VisitorDiscoverController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.stats.isEmpty) {
        return _StatsShimmer();
      }

      final stats = controller.stats;
      if (stats.isEmpty) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(label: "Exhibitors", value: "${stats['exhibitors_in_expo'] ?? 0}"),
          _StatItem(label: "Saved", value: "${stats['saved'] ?? 0}"),
          _StatItem(label: "Favorites", value: "${stats['favorites'] ?? 0}"),
          _StatItem(label: "Followups", value: "${stats['followups'] ?? 0}"),
        ],
      );
    });
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.subheading.copyWith(color: AppColors.primary)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _StatsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) => Column(
          children: [
            Container(
              width: 30.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              width: 50.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
        itemCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 90.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 20.r,
                height: 20.r,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search exhibitors, booths...',
          hintStyle: AppTextStyles.subText,
          icon: Icon(Icons.search, color: AppColors.textSecondary, size: 20.sp),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}

class _CategoryFilters extends GetView<VisitorDiscoverController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
            () => Row(
          children: controller.categories.map((cat) {
            final isSelected = controller.selectedCategory.value == cat;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => controller.selectCategory(cat),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ExhibitorCard extends StatelessWidget {
  const _ExhibitorCard({required this.exhibitor, this.onFavoriteTap});
  final ExhibitorModel exhibitor;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Text(
              exhibitor.initials,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exhibitor.name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${exhibitor.hall} • ${exhibitor.booth}",
                  style: AppTextStyles.subText,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onFavoriteTap,
            icon: Icon(
              exhibitor.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: exhibitor.isFavorite ? AppColors.primary : AppColors.textSecondary,
              size: 20.sp,
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
