import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class DrawerIconButton extends StatefulWidget {
  const DrawerIconButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<DrawerIconButton> createState() => _DrawerIconButtonState();
}

class _DrawerIconButtonState extends State<DrawerIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(widget.icon, size: 19, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}