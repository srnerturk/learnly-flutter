import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/learnly_logo.dart';
import '../../../../shared/widgets/pro_badge.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isPro;
  final int xpPoints;

  const HomeAppBar({
    super.key,
    this.isPro = false,
    this.xpPoints = 1240,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const LearnlyLogo(),
            const Gap(8),
            if (!isPro)
              ProBadge(onTap: () {
                // TODO: open paywall
              }),
            const Spacer(),
            _XpBadge(xp: xpPoints),
            const Gap(8),
            _AppBarIconButton(
              icon: Icons.search_rounded,
              onTap: () {},
            ),
            const Gap(8),
            _AppBarIconButton(
              icon: Icons.notifications_outlined,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _XpBadge extends StatelessWidget {
  final int xp;
  const _XpBadge({required this.xp});

  String _format(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⚡', style: TextStyle(fontSize: 12)),
          const Gap(5),
          Text(
            '${_format(xp)} XP',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 19),
      ),
    );
  }
}
