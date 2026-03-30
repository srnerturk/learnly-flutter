import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

void showPaywallSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const PaywallSheet(),
  );
}

class PaywallSheet extends StatefulWidget {
  const PaywallSheet({super.key});

  @override
  State<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<PaywallSheet> {
  bool _isYearly = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _PaywallHeader()
                      .animate()
                      .fadeIn(duration: 350.ms),
                  const Gap(28),
                  _FeaturesList()
                      .animate()
                      .fadeIn(duration: 350.ms, delay: 80.ms)
                      .slideY(begin: 0.04, end: 0),
                  const Gap(28),
                  _PlanSelector(
                    isYearly: _isYearly,
                    onChanged: (v) => setState(() => _isYearly = v),
                  )
                      .animate()
                      .fadeIn(duration: 350.ms, delay: 160.ms)
                      .slideY(begin: 0.04, end: 0),
                  const Gap(24),
                  _SubscribeButton(isYearly: _isYearly)
                      .animate()
                      .fadeIn(duration: 350.ms, delay: 220.ms),
                  const Gap(12),
                  _FooterLinks()
                      .animate()
                      .fadeIn(duration: 350.ms, delay: 280.ms),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _PaywallHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gold gradient background
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1200), Color(0xFF0C0B14)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Crown icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.goldGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.5),
                      blurRadius: 28,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.bolt_rounded, color: Colors.black, size: 36),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(begin: 0.94, end: 1.0, duration: 1000.ms),
              const Gap(16),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.goldGradient,
                ).createShader(bounds),
                child: const Text(
                  'Learnly PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const Gap(8),
              Text(
                'Öğrenmenin sınırlarını kaldır',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        // Close button
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.close_rounded,
                  color: AppColors.textSecondary, size: 17),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Features ─────────────────────────────────────────────────────────────────

const _features = [
  (icon: Icons.all_inclusive_rounded, label: 'Sınırsız içerik oluşturma'),
  (icon: Icons.mic_rounded, label: 'Tüm AI ses seçenekleri'),
  (icon: Icons.bolt_rounded, label: 'Öncelikli ve hızlı işleme'),
  (icon: Icons.block_rounded, label: 'Reklamsız deneyim'),
  (icon: Icons.share_rounded, label: 'İçerik paylaşma özelliği'),
  (icon: Icons.bar_chart_rounded, label: 'Detaylı öğrenme istatistikleri'),
];

class _FeaturesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PRO Avantajları', style: AppTextStyles.titleMedium),
          const Gap(14),
          ..._features.asMap().entries.map((e) => _FeatureRow(
                feature: e.value,
                delay: Duration(milliseconds: 40 * e.key),
              )),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final ({IconData icon, String label}) feature;
  final Duration delay;

  const _FeatureRow({required this.feature, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Icon(feature.icon, color: AppColors.gold, size: 17),
            ),
          ),
          const Gap(12),
          Text(feature.label, style: AppTextStyles.bodyLarge),
          const Spacer(),
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 18),
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 260.ms)
        .slideX(begin: 0.04, end: 0);
  }
}

// ─── Plan Selector ────────────────────────────────────────────────────────────

class _PlanSelector extends StatelessWidget {
  final bool isYearly;
  final ValueChanged<bool> onChanged;

  const _PlanSelector({required this.isYearly, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan Seç', style: AppTextStyles.titleMedium),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: _PlanCard(
                  title: 'Aylık',
                  price: '₺79,99',
                  sub: 'ay başına',
                  isSelected: !isYearly,
                  badge: null,
                  onTap: () => onChanged(false),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _PlanCard(
                  title: 'Yıllık',
                  price: '₺599,99',
                  sub: '≈ ₺50/ay',
                  isSelected: isYearly,
                  badge: '%38 İndirim',
                  onTap: () => onChanged(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String sub;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.sub,
    required this.isSelected,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withValues(alpha: 0.07)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isSelected ? AppColors.gold : AppColors.textPrimary,
                  ),
                ),
                if (badge != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.goldGradient),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const Gap(10),
            Text(
              price,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isSelected ? AppColors.gold : AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const Gap(2),
            Text(
              sub,
              style: AppTextStyles.bodySmall,
            ),
            const Gap(10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.gold : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Subscribe Button ─────────────────────────────────────────────────────────

class _SubscribeButton extends StatelessWidget {
  final bool isYearly;
  const _SubscribeButton({required this.isYearly});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              // TODO: initiate purchase
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.goldGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'PRO\'ya Geç ⚡',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    isYearly
                        ? 'Yıllık · ₺599,99 — %38 tasarruf'
                        : 'Aylık · ₺79,99',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
          Text(
            'Dilediğin zaman iptal edebilirsin',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _FooterLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Link(label: 'Satın Alımı Geri Yükle', onTap: () {}),
        Container(
          width: 1,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: AppColors.border,
        ),
        _Link(label: 'Gizlilik Politikası', onTap: () {}),
        Container(
          width: 1,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: AppColors.border,
        ),
        _Link(label: 'Kullanım Koşulları', onTap: () {}),
      ],
    );
  }
}

class _Link extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Link({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: AppColors.textTertiary,
        ),
      ),
    );
  }
}
