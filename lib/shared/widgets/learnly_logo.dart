import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LearnlyLogo extends StatelessWidget {
  final double size;
  const LearnlyLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Center(
            child: Text(
              'L',
              style: TextStyle(
                color: AppColors.background,
                fontSize: size * 0.56,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Learnly',
          style: AppTextStyles.titleLarge.copyWith(
            letterSpacing: -0.4,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
