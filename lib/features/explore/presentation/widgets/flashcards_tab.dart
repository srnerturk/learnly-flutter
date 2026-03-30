import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/learning_item.dart';

const _mockCards = [
  ('Temel Tanım', 'Konunun çekirdeğini oluşturan ana kavram ve bunun genel çerçevesi'),
  ('Önemli İsim', 'Bu alanın gelişimine en büyük katkıyı yapan kişi veya kurum'),
  ('Kritik Tarih', 'Konunun tarihsel gelişimindeki en önemli dönüm noktası'),
  ('Güncel Uygulama', 'Bu kavramın bugün hayatımızda nasıl karşılık bulduğu'),
  ('Temel İlke', 'Konuyu açıklayan en temel kural veya yasa'),
];

class FlashcardsTab extends StatefulWidget {
  final LearningItem item;
  const FlashcardsTab({super.key, required this.item});

  @override
  State<FlashcardsTab> createState() => _FlashcardsTabState();
}

class _FlashcardsTabState extends State<FlashcardsTab>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  bool _flipped = false;
  late final AnimationController _flipCtrl;
  late final Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_flipped) {
      _flipCtrl.reverse();
    } else {
      _flipCtrl.forward();
    }
    setState(() => _flipped = !_flipped);
  }

  void _next() {
    if (_index < _mockCards.length - 1) {
      setState(() {
        _index++;
        _flipped = false;
      });
      _flipCtrl.reset();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _flipped = false;
      });
      _flipCtrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = _mockCards[_index];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Progress
          _ProgressRow(current: _index + 1, total: _mockCards.length),
          const Gap(28),
          // Flip card
          GestureDetector(
            onTap: _flip,
            child: AnimatedBuilder(
              animation: _flipAnim,
              builder: (context, child) {
                final isBack = _flipAnim.value >= 0.5;
                final angle = _flipAnim.value * pi;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: isBack
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: _CardFace(
                            text: card.$2,
                            isBack: true,
                            label: 'CEVAP',
                          ),
                        )
                      : _CardFace(
                          text: card.$1,
                          isBack: false,
                          label: 'SORU',
                        ),
                );
              },
            ),
          ).animate().fadeIn(duration: 250.ms),
          const Gap(16),
          Text(
            _flipped ? 'Dokunarak soruya dön' : 'Dokunarak cevabı gör',
            style: AppTextStyles.bodySmall,
          ),
          const Gap(32),
          // Navigation
          Row(
            children: [
              Expanded(
                child: _NavButton(
                  label: 'Önceki',
                  icon: Icons.arrow_back_rounded,
                  enabled: _index > 0,
                  onTap: _prev,
                  isPrimary: false,
                ),
              ),
              const Gap(12),
              Expanded(
                child: _NavButton(
                  label: _index == _mockCards.length - 1 ? 'Bitti 🎉' : 'Sonraki',
                  icon: Icons.arrow_forward_rounded,
                  enabled: true,
                  onTap: _index == _mockCards.length - 1 ? () {} : _next,
                  isPrimary: true,
                ),
              ),
            ],
          ),
          const Gap(24),
          _ResultBar(index: _index, total: _mockCards.length),
        ],
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final String text;
  final bool isBack;
  final String label;

  const _CardFace(
      {required this.text, required this.isBack, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isBack
              ? [const Color(0xFF00E676), const Color(0xFF00B09B)]
              : AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (isBack ? AppColors.success : AppColors.primary)
                .withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Label
          Positioned(
            top: 16,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          // Icon
          Positioned(
            top: 12,
            right: 16,
            child: Icon(
              isBack ? Icons.check_circle_rounded : Icons.help_outline_rounded,
              color: Colors.white.withValues(alpha: 0.4),
              size: 22,
            ),
          ),
          // Card text
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressRow({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kart $current / $total', style: AppTextStyles.labelMedium),
            Text('${((current / total) * 100).round()}%',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.primary)),
          ],
        ),
        const Gap(8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: AppColors.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final bool isPrimary;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary && enabled
              ? const LinearGradient(colors: AppColors.primaryGradient)
              : null,
          color: (!isPrimary || !enabled) ? AppColors.surfaceVariant : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled && isPrimary ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isPrimary && enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPrimary) Icon(icon, size: 16, color: enabled ? AppColors.textSecondary : AppColors.border),
            if (!isPrimary) const Gap(6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isPrimary && enabled
                    ? AppColors.background
                    : enabled
                        ? AppColors.textSecondary
                        : AppColors.border,
              ),
            ),
            if (isPrimary && _needsArrow) const Gap(6),
            if (isPrimary && _needsArrow)
              Icon(icon, size: 16, color: AppColors.background),
          ],
        ),
      ),
    );
  }

  bool get _needsArrow => label != 'Bitti 🎉';
}

class _ResultBar extends StatelessWidget {
  final int index;
  final int total;

  const _ResultBar({required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Toplam', value: '$total', color: AppColors.textPrimary),
          _StatItem(label: 'Görülen', value: '${index + 1}', color: AppColors.primary),
          _StatItem(label: 'Kalan', value: '${total - index - 1}', color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        const Gap(2),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
