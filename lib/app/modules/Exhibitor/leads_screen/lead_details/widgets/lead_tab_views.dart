import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/utils/app_colors.dart';
import '../controller/lead_details_controller.dart';

class NoteTabView extends GetWidget<LeadDetailsController> {
  const NoteTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  controller: controller.notesController,
                  maxLines: null,
                  minLines: 2,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'Add a professional note about this lead...',
                    hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => ElevatedButton(
                          onPressed: controller.isSubmittingNote.value ? null : controller.submitNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          ),
                          child: controller.isSubmittingNote.value
                              ? SizedBox(height: 16.r, width: 16.r, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text('Save Note', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('INTERACTION HISTORY',
                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
            Obx(() => Text('${controller.notes.length} entries', style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary))),
          ],
        ),
        SizedBox(height: 12.h),
        Obx(() {
          if (controller.notes.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                children: [
                  Icon(Icons.notes_rounded, color: AppColors.border, size: 40.sp),
                  SizedBox(height: 12.h),
                  Text('No history found', style: AppTextStyles.subText),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.notes.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12.r,
                          backgroundColor: AppColors.primarySoft,
                          child: Text(note.createdByName.isNotEmpty ? note.createdByName[0] : '?',
                              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ),
                        SizedBox(width: 8.w),
                        Text(note.createdByName,
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const Spacer(),
                        Text(
                          '${note.createdAt.day} ${_getMonth(note.createdAt.month)}, ${note.createdAt.hour}:${note.createdAt.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      note.note,
                      style: TextStyle(fontSize: 13.5.sp, height: 1.5, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
            },
          );
        }),
      ],
    );
  }

  String _getMonth(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return (m > 0 && m <= 12) ? months[m - 1] : '';
  }
}

class TagsProductsTabView extends GetWidget<LeadDetailsController> {
  const TagsProductsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputSection(
          title: 'Tags',
          hint: 'Add a tag...',
          controller: controller.tagsController,
          isLoading: controller.isSubmittingTag,
          onAdd: controller.submitTag,
        ),
        SizedBox(height: 12.h),
        Obx(() => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.tags
                  .map((tag) => TagChip(
                        label: tag.name,
                        color: _hexToColor(tag.color),
                        onDelete: () => controller.deleteTag(tag.id),
                        isDeleting: controller.isDeletingTag.value == tag.id,
                      ))
                  .toList(),
            )),
        SizedBox(height: 24.h),
        _buildInputSection(
          title: 'Products',
          hint: 'Add a product...',
          controller: controller.productsController,
          isLoading: controller.isSubmittingProduct,
          onAdd: controller.submitProduct,
        ),
        SizedBox(height: 12.h),
        Obx(() => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.products
                  .map((product) => TagChip(
                        label: product.name,
                        color: AppColors.primarySoft,
                        textColor: AppColors.primaryDark,
                        onDelete: () => controller.deleteProduct(product.id),
                        isDeleting: controller.isDeletingProduct.value == product.id,
                      ))
                  .toList(),
            )),
      ],
    );
  }

  Widget _buildInputSection({
    required String title,
    required String hint,
    required TextEditingController controller,
    required RxBool isLoading,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Obx(() => IconButton(
                    onPressed: isLoading.value ? null : onAdd,
                    icon: isLoading.value
                        ? SizedBox(height: 16.r, width: 16.r, child: const CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
    this.onDelete,
    this.isDeleting = false,
  });
  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback? onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, top: 6.h, bottom: 6.h, right: onDelete != null ? 6.w : 12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textColor ?? color.withOpacity(0.9),
            ),
          ),
          if (onDelete != null) ...[
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: isDeleting ? null : onDelete,
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
                child: isDeleting
                    ? SizedBox(
                        width: 10.r,
                        height: 10.r,
                        child: CircularProgressIndicator(strokeWidth: 1.5, color: textColor ?? color),
                      )
                    : Icon(Icons.close_rounded, size: 12.sp, color: textColor ?? color),
              ),
            ),
          ],
        ],
      ),
    ).animate().scale(duration: 200.ms);
  }
}

class FollowUpTabView extends GetWidget<LeadDetailsController> {
  const FollowUpTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Obx(() => Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.editingFollowUpId.value != null ? 'EDIT FOLLOW-UP' : 'SCHEDULE FOLLOW-UP',
                            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary),
                          ),
                          if (controller.editingFollowUpId.value != null)
                            GestureDetector(
                              onTap: controller.cancelEditingFollowUp,
                              child: Text('Cancel',
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.error, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      InkWell(
                        onTap: () => _selectDateTime(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 18.sp, color: AppColors.primary),
                              SizedBox(width: 12.w),
                              Text(
                                controller.selectedFollowUpDate.value == null
                                    ? 'Select Date & Time'
                                    : DateFormat('MMM dd, yyyy - hh:mm a').format(controller.selectedFollowUpDate.value!),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: controller.selectedFollowUpDate.value == null
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ChannelDropdown(
                        value: controller.selectedChannel.value,
                        onChanged: (val) => controller.selectedChannel.value = val!,
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: controller.followUpRemarksController,
                        maxLines: 2,
                        style: TextStyle(fontSize: 13.sp, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Add remarks...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                          fillColor: AppColors.background,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isSubmittingFollowUp.value ? null : controller.submitFollowUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.editingFollowUpId.value != null ? Colors.blue : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                          child: controller.isSubmittingFollowUp.value
                              ? SizedBox(height: 20.r, width: 20.r, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(
                                  controller.editingFollowUpId.value != null ? 'Update Follow-up' : 'Add Follow-up',
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                  if (controller.isLoadingFollowUpDetails.value)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: SizedBox(
                            width: 24.r,
                            height: 24.r,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        ),
        SizedBox(height: 10.h),
        Text('UPCOMING & PAST FOLLOW-UPS',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
        Obx(() {
          if (controller.followUps.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Column(
                  children: [
                    Icon(Icons.event_note_rounded, color: AppColors.border, size: 40.sp),
                    SizedBox(height: 8.h),
                    Text('No follow-ups scheduled', style: AppTextStyles.subText),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.followUps.length,
            separatorBuilder: (_, __) => SizedBox(height: 6.h),
            itemBuilder: (context, index) {
              final fu = controller.followUps[index];
              return FollowUpCard(followUp: fu);
            },
          );
        }),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedFollowUpDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: controller.selectedFollowUpDate.value != null
            ? TimeOfDay.fromDateTime(controller.selectedFollowUpDate.value!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        controller.selectedFollowUpDate.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }
}

class FollowUpCard extends GetWidget<LeadDetailsController> {
  const FollowUpCard({super.key, required this.followUp});
  final LeadFollowUp followUp;

  @override
  Widget build(BuildContext context) {
    final isCompleted = followUp.status.toLowerCase() == 'completed';

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => controller.showFollowUpDetails(followUp.id),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: _getChannelColor(followUp.channel).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getChannelIcon(followUp.channel), size: 14.sp, color: _getChannelColor(followUp.channel)),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy • hh:mm a').format(followUp.followUpAt),
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        Text(
                          followUp.channel.toUpperCase(),
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => controller.isDeletingFollowUp.value == followUp.id
                      ? SizedBox(width: 16.r, height: 16.r, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit_outlined, color: Colors.blue, size: 20.sp),
                              onPressed: () => controller.fetchAndStartEditingFollowUp(followUp.id),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.all(8.r),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20.sp),
                              onPressed: () => controller.deleteFollowUp(followUp.id),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.all(8.r),
                            ),
                          ],
                        )),
                ],
              ),
              SizedBox(height: 5.h),
              followUp.remarks.isNotEmpty
                  ? Text(followUp.remarks,
                      maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary))
                  : SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusBadge(status: followUp.status),
                  if (!isCompleted)
                    TextButton.icon(
                      onPressed: () => controller.updateFollowUpStatus(followUp, 'completed'),
                      icon: Icon(Icons.check_circle_outline_rounded, size: 16.sp),
                      label: Text('Mark Complete', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(foregroundColor: Colors.green, padding: EdgeInsets.zero),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getChannelIcon(String channel) {
    switch (channel.toLowerCase()) {
      case 'call': return Icons.phone_rounded;
      case 'email': return Icons.email_rounded;
      case 'whatsapp': return Icons.chat_rounded;
      case 'meeting': return Icons.people_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _getChannelColor(String channel) {
    switch (channel.toLowerCase()) {
      case 'call': return AppColors.primary;
      case 'email': return Colors.orange;
      case 'whatsapp': return const Color(0xFF25D366);
      case 'meeting': return Colors.purple;
      default: return AppColors.textSecondary;
    }
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final isCompleted = status.toLowerCase() == 'completed';
    final color = isCompleted ? Colors.green : Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

class ChannelDropdown extends StatelessWidget {
  const ChannelDropdown({super.key, required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final List<String> allowedChannels = ['email', 'call', 'whatsapp', 'meeting', 'other'];
    final String safeValue = allowedChannels.contains(value.toLowerCase()) ? value.toLowerCase() : 'other';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
          onChanged: onChanged,
          items: allowedChannels.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val.toUpperCase()),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DocumentsTabView extends GetWidget<LeadDetailsController> {
  const DocumentsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.pickAndUploadDocument(),
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Obx(() => Column(
                      children: [
                        if (controller.isUploadingDocument.value)
                          SizedBox(height: 24.r, width: 24.r, child: const CircularProgressIndicator(strokeWidth: 2))
                        else
                          Icon(Icons.cloud_upload_outlined, size: 32.sp, color: AppColors.primary),
                        SizedBox(height: 8.h),
                        Text(
                          controller.isUploadingDocument.value ? 'Uploading...' : 'Upload new document',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 4.h),
                        Text('Images only (max 5MB)', style: AppTextStyles.subText.copyWith(fontSize: 12.sp)),
                      ],
                    )),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Text('UPLOADED DOCUMENTS',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
        SizedBox(height: 12.h),
        Obx(() {
          if (controller.documents.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Column(
                  children: [
                    Icon(Icons.description_outlined, color: AppColors.border, size: 40.sp),
                    SizedBox(height: 8.h),
                    Text('No documents uploaded', style: AppTextStyles.subText),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.documents.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final doc = controller.documents[index];
              return DocumentCard(document: doc);
            },
          );
        }),
      ],
    );
  }
}

class DocumentCard extends GetWidget<LeadDetailsController> {
  const DocumentCard({super.key, required this.document});
  final LeadDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.image_outlined, color: AppColors.primary, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.fileName,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.visibility_outlined, color: AppColors.primary, size: 20.sp),
            onPressed: () => controller.viewDocument(document.fileUrl),
          ),
          Obx(() => controller.isDeletingDocument.value == document.id
              ? SizedBox(width: 20.r, height: 20.r, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.red))
              : IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20.sp),
                  onPressed: () => controller.deleteDocument(document.id),
                )),
        ],
      ),
    );
  }
}
