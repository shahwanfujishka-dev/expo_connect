import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/utils/app_colors.dart';
import 'controller/QrScan_controller.dart';

class QrScanScreen extends GetView<QrScanController> {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1A12),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: Icon(Icons.close_rounded, color: Colors.white, size: 24.sp),
                  ),
                  const Spacer(),
                  Text(
                    'Scan QR code',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 48.w), // balances the close button
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: controller.scannerController,
                    onDetect: controller.onCodeDetected,
                  ),
                  _ScanFrame(),
                  Obx(
                    () => controller.isProcessing.value
                        ? const CircularProgressIndicator(color: AppColors.primary)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                children: [
                  Obx(
                    () => controller.errorText.value != null
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              controller.errorText.value!,
                              style: TextStyle(color: AppColors.error, fontSize: 13.sp),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Text(
                    'Align the visitor\'s QR code within the frame',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13.sp),
                    textAlign: TextAlign.center,
                  ),
                  if (kDebugMode) ...[
                    SizedBox(height: 14.h),
                    TextButton(
                      onPressed: controller.simulateScanTapped,
                      child: Text(
                        'Simulate scan (debug only)',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = 260.0.w;
    final corner = 28.0.w;
    final thickness = 3.0.w;

    Widget bracket({required bool top, required bool left}) {
      return Positioned(
        top: top ? 0 : null,
        bottom: top ? null : 0,
        left: left ? 0 : null,
        right: left ? null : 0,
        child: SizedBox(
          width: corner,
          height: corner,
          child: CustomPaint(
            painter: _BracketPainter(top: top, left: left, thickness: thickness),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          bracket(top: true, left: true),
          bracket(top: true, left: false),
          bracket(top: false, left: true),
          bracket(top: false, left: false),
        ],
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  _BracketPainter({required this.top, required this.left, required this.thickness});
  final bool top;
  final bool left;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (top && left) {
      path
        ..moveTo(0, size.height)
        ..lineTo(0, 0)
        ..lineTo(size.width, 0);
    } else if (top && !left) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height);
    } else if (!top && left) {
      path
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
