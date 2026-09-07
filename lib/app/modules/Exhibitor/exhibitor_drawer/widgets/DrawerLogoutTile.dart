import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class DrawerLogoutTile extends StatefulWidget {
  const DrawerLogoutTile({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<DrawerLogoutTile> createState() => _DrawerLogoutTileState();
}

class _DrawerLogoutTileState extends State<DrawerLogoutTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const color = AppColors.error;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: _pressed ? 0.97 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _hovered ? color.withOpacity(0.07) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.logout_rounded, size: 20, color: color),
                SizedBox(width: 14),
                Text(
                  'Log out',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}