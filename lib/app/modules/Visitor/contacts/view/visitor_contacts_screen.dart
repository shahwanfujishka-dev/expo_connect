import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../../../../data/services/endpoints.dart';
import '../../../../routes/app_routes.dart';
import '../controller/visitor_contacts_controller.dart';
import '../../visitor_main/controller/visitor_main_controller.dart';
import '../../visitor_appbar/VisitorAppBar.dart';

class VisitorContactsScreen extends GetView<VisitorContactsController> {
  const VisitorContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<VisitorMainController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VisitorAppBar(
        title: 'My contact book',
        onMenuTap: mainController.toggleDrawer,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
            child: _TabSelector(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.contacts.isEmpty) {
                return _LoadingShimmer();
              }

              if (controller.contacts.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.fetchContacts,
                  child: ListView(
                    children: [
                      SizedBox(height: 100.h),
                      const Center(child: Text("No contacts found")),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchContacts,
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  itemCount: controller.contacts.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final exhibitor = controller.contacts[index];
                    return _ContactTile(exhibitor: exhibitor);
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

class _TabSelector extends GetView<VisitorContactsController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tabItem("All", 0),
        SizedBox(width: 12.w),
        _tabItem("Favorites", 1),
      ],
    );
  }

  Widget _tabItem(String label, int index) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return GestureDetector(
        onTap: () => controller.setTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}

class _ContactTile extends GetView<VisitorContactsController> {
  const _ContactTile({required this.exhibitor});
  final ExhibitorModel exhibitor;

  @override
  Widget build(BuildContext context) {
    final logoUrl = exhibitor.logoUrl != null && exhibitor.logoUrl!.isNotEmpty
        ? "${Endpoints.storageUrl}${exhibitor.logoUrl}"
        : null;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(
          Routes.VISITOR_CONTACT_DETAILS,
          arguments: exhibitor,
        )?.then((_) => controller.fetchContacts()),
        borderRadius: BorderRadius.circular(14.r),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: logoUrl != null
                        ? Image.network(
                      logoUrl,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (_, __, ___) => _buildInitial(),
                    )
                        : _buildInitial(),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          if (exhibitor.planStatus != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                exhibitor.planStatus!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (exhibitor.planStatus != null) SizedBox(width: 6.w),
                          Text(
                            exhibitor.hall.isNotEmpty ? "Hall ${exhibitor.hall}" : "Booth ${exhibitor.booth}",
                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => controller.toggleFavorite(exhibitor),
                  icon: Icon(
                    exhibitor.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: exhibitor.isFavorite ? Colors.red : AppColors.textSecondary,
                    size: 22.sp,
                  ),
                ),
                _buildMoreOptions(context),
              ],
            ),
            if (exhibitor.notes != null && exhibitor.notes!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes, size: 14.sp, color: AppColors.textSecondary),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          exhibitor.notes!,
                          style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOptions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20.sp),
      onSelected: (value) {
        if (exhibitor.contactId == null) return;
        switch (value) {
          case 'status':
            _showStatusDialog(context);
            break;
          case 'notes':
            _showNotesDialog(context);
            break;
          case 'delete':
            _showDeleteConfirmation();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'status', child: Text('Update Status')),
        const PopupMenuItem(value: 'notes', child: Text('Edit Notes')),
        const PopupMenuItem(value: 'delete', child: Text('Remove Contact', style: TextStyle(color: Colors.red))),
      ],
    );
  }

  void _showStatusDialog(BuildContext context) {
    Get.dialog(
      SimpleDialog(
        title: const Text('Move to'),
        children: [
          _statusOption('visited'),
          _statusOption('planned'),
          _statusOption('not_visited'),
        ],
      ),
    );
  }

  Widget _statusOption(String status) {
    return SimpleDialogOption(
      onPressed: () {
        Get.back();
        controller.updateStatus(exhibitor.contactId!, status);
      },
      child: Text(status.replaceAll('_', ' ').capitalizeFirst!),
    );
  }

  void _showNotesDialog(BuildContext context) {
    final notesController = TextEditingController(text: exhibitor.notes);
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Notes'),
        content: TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter your notes here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateNotes(exhibitor.contactId!, notesController.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Contact'),
        content: const Text('Are you sure you want to remove this exhibitor from your contact book?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteContact(exhibitor.contactId!);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildInitial() {
    return Center(
      child: Text(
        exhibitor.initials,
        style: TextStyle(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
        ),
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
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => Container(
          height: 72.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}
