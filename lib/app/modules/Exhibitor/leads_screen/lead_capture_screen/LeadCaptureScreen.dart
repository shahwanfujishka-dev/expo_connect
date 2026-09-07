import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import 'controller/lead_capture_controller.dart';

class LeadCaptureScreen extends GetView<LeadCaptureController> {
  const LeadCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
               Text('Capture a lead', style: AppTextStyles.heading),
              const SizedBox(height: 24),
              _CaptureOption(
                icon: Icons.qr_code_scanner_rounded,
                title: 'Scan QR code',
                subtitle: 'Fastest — reads visitor\'s badge',
                highlighted: true,
                onTap: controller.scanQrTapped,
              ),
              const SizedBox(height: 12),
              _CaptureOption(
                icon: Icons.badge_outlined,
                title: 'Scan business card',
                subtitle: 'AI reads the card automatically',
                onTap: controller.scanCardTapped,
              ),
              const SizedBox(height: 12),
              _CaptureOption(
                icon: Icons.edit_note_rounded,
                title: 'Manual entry',
                subtitle: 'Type in visitor details',
                dark: true,
                onTap: controller.manualEntryTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaptureOption extends StatelessWidget {
  const _CaptureOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
    this.dark = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg = dark
        ? AppColors.textPrimary
        : (highlighted ? AppColors.primarySoft : AppColors.surface);
    final fg = dark ? Colors.white : AppColors.textPrimary;
    final iconBg = dark ? Colors.white24 : AppColors.primary;
    final iconFg = Colors.white;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlighted ? AppColors.primary : AppColors.border,
              width: highlighted ? 1.4 : (dark ? 0 : 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(11)),
                alignment: Alignment.center,
                child: Icon(icon, color: iconFg, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: fg)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: dark ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: dark ? Colors.white70 : AppColors.border),
            ],
          ),
        ),
      ),
    );
  }
}