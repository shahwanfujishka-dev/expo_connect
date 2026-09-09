import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../controller/events_controller.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Events', style: AppTextStyles.subheading),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.upcomingEvents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.upcomingEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note_outlined, size: 80.r, color: AppColors.border),
                SizedBox(height: 16.h),
                Text('No events joined yet', style: AppTextStyles.body),
                SizedBox(height: 8.h),
                Text('Tap the + button to join or create an event', style: AppTextStyles.subText),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUpcomingEvents,
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.upcomingEvents.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final event = controller.upcomingEvents[index];
              return InkWell(
                onTap: () {
                  controller.fetchEventDetails(event.id);
                  Get.toNamed(Routes.EVENT_DETAILS);
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.name,
                              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              event.status?.toUpperCase() ?? 'UPCOMING',
                              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16.r, color: AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              event.venue ?? 'Venue not specified',
                              style: AppTextStyles.subText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 16.r, color: AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Text(
                            event.startDate != null
                                ? DateFormat('dd-MM-yyyy').format(event.startDate!)
                                : 'TBA',
                            style: AppTextStyles.subText,
                          ),
                          Text(' to ', style: AppTextStyles.subText),
                          Text(
                            event.endDate != null
                                ? DateFormat('dd-MM-yyyy').format(event.endDate!)
                                : 'TBA',
                            style: AppTextStyles.subText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_EVENT),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
