import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/exhibitor_model.dart';
import '../controller/visitor_compare_controller.dart';

class VisitorCompareScreen extends GetView<VisitorCompareController> {
  const VisitorCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Compare', style: AppTextStyles.subheading),
      ),
      body: Obx(() {
        if (controller.exhibitorsToCompare.length < 2) {
          return const Center(child: Text("Select at least 2 exhibitors to compare"));
        }
        return Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  ...controller.exhibitorsToCompare.map((e) => Expanded(
                        child: Center(
                          child: Text(
                            e.name,
                            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.comparisonMetrics.length,
                  separatorBuilder: (_, __) => Divider(height: 32.h, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final metric = controller.comparisonMetrics[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            metric,
                            style: AppTextStyles.subText.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ...controller.exhibitorsToCompare.map((e) => Expanded(
                              child: Center(
                                child: Text(
                                  controller.getMetricValue(e, metric),
                                  style: AppTextStyles.body,
                                ),
                              ),
                            )),
                      ],
                    );
                  },
                ),
              ),
              PrimaryButton(
                label: "Export Comparison",
                onPressed: () => Get.snackbar("Export", "Comparison report generated"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
