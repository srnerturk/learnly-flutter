import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProBadge extends StatelessWidget {
  final VoidCallback? onTap;

  const ProBadge({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.proGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, size: 11, color: Colors.black),
            const SizedBox(width: 3),
            const Text(
              'PRO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
