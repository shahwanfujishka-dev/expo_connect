import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'DrawerIconButton.dart';

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({super.key, required this.companyName, required this.onClose});

  final String companyName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final firstLetter = companyName.trim().isNotEmpty ? companyName.trim()[0].toUpperCase() : 'E';

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.20),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              firstLetter,
              style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName.isEmpty ? 'Your Company' : companyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'EXHIBITOR',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DrawerIconButton(icon: Icons.close_rounded, onTap: onClose),
        ],
      ),
    );
  }
}