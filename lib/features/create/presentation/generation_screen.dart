import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/create_session.dart';

void showGenerationScreen(BuildContext context, CreateSession session) {
  Navigator.of(context).push(
    PageRouteBuilder(
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, _) =>
          GenerationScreen(session: session),
      transitionsBuilder: (context, animation, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    ),
  );
}

class GenerationScreen extends StatefulWidget {
  final CreateSession session;
  const GenerationScreen({super.key, required this.session});

  @override
  State<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  final List<_ItemProgress> _items = [];

  @override
  void initState() {
    super.initState();
    _buildItems();
    _simulateProgress();
  }

  void _buildItems() {
    for (final type in widget.session.contentTypes) {
      _items.add(_ItemProgress(type: type));
    }
  }

  Future<void> _simulateProgress() async {
    for (var i = 0; i < _items.length; i++) {
      await Future.delayed(Duration(milliseconds: 800 + i * 400));
      if (!mounted) return;
      // Kick off progress animation per item — items animate themselves
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onClose: () => Navigator.of(context).pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    _HeroSection().animate().fadeIn(duration: 400.ms),
                    const Gap(32),
                    _GeneratingItemsList(items: _items),
                    const Gap(32),
                    const _NotificationInfoCard()
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 400.ms)
                        .slideY(begin: 0.06, end: 0),
                    const Gap(24),
                    _CloseButton(onTap: () => Navigator.of(context).pop())
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 500.ms),
                    const Gap(12),
                    _SecondaryClose(onTap: () => Navigator.of(context).pop())
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 600.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onClose;
  const _TopBar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.close_rounded,
                  color: AppColors.textSecondary, size: 18),
            ),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .scaleXY(begin: 1, end: 1.18, duration: 1400.ms)
                .then()
                .scaleXY(begin: 1.18, end: 1, duration: 1400.ms)
                .fadeIn(),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.45),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome_rounded,
                    color: AppColors.primary, size: 34),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.92, end: 1.0, duration: 900.ms, curve: Curves.easeInOut),
          ],
        ),
        const Gap(20),
        Text(
          'İçeriğin Oluşturuluyor',
          style: AppTextStyles.displayMedium,
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          'Bu işlem birkaç dakika sürebilir',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Generating Items ─────────────────────────────────────────────────────────

class _ItemProgress {
  final ContentType type;
  _ItemProgress({required this.type});
}

class _GeneratingItemsList extends StatelessWidget {
  final List<_ItemProgress> items;
  const _GeneratingItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Oluşturulan İçerikler', style: AppTextStyles.titleSmall),
        const Gap(12),
        ...items.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GeneratingItem(
                type: e.value.type,
                delay: Duration(milliseconds: e.key * 120),
              ),
            )),
      ],
    );
  }
}

class _GeneratingItem extends StatelessWidget {
  final ContentType type;
  final Duration delay;

  const _GeneratingItem({required this.type, required this.delay});

  Color get _color {
    switch (type) {
      case ContentType.audioSummary: return AppColors.primary;
      case ContentType.flashcards: return AppColors.accent;
      case ContentType.quiz: return AppColors.success;
      case ContentType.textSummary: return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _color.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Icon(type.icon, color: _color, size: 20),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.label, style: AppTextStyles.titleSmall),
                const Gap(8),
                _AnimatedProgressBar(color: _color, delay: delay),
              ],
            ),
          ),
          const Gap(10),
          _SpinningLoader(color: _color),
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.06, end: 0);
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final Color color;
  final Duration delay;

  const _AnimatedProgressBar({required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          Container(height: 5, color: AppColors.border),
          Container(height: 5, color: color)
              .animate(delay: delay + 200.ms, onPlay: (c) => c.repeat())
              .shimmer(
                duration: 1600.ms,
                color: color.withValues(alpha: 0.6),
              )
              .animate()
              .custom(
                duration: 3000.ms,
                delay: delay,
                curve: Curves.easeInOut,
                builder: (context, value, child) => FractionallySizedBox(
                  widthFactor: (value * 0.75).clamp(0.0, 1.0),
                  child: child,
                ),
              ),
        ],
      ),
    );
  }
}

class _SpinningLoader extends StatelessWidget {
  final Color color;
  const _SpinningLoader({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: color.withValues(alpha: 0.15),
      ),
    ).animate(onPlay: (c) => c.repeat()).rotate(duration: 1000.ms);
  }
}

// ─── Notification Info ────────────────────────────────────────────────────────

class _NotificationInfoCard extends StatelessWidget {
  const _NotificationInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🔔', style: TextStyle(fontSize: 18)),
            ),
          ),
          const Gap(12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bildirim Alacaksın',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(4),
                Text(
                  'İçerik hazır olduğunda sana bildirim göndereceğiz. Bu ekranı kapatıp uygulamayı kullanmaya devam edebilirsin.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Buttons ──────────────────────────────────────────────────────────────────

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'Tamam, Kapat',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.background,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SecondaryClose extends StatelessWidget {
  final VoidCallback onTap;
  const _SecondaryClose({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        'Arka planda devam et',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.textTertiary,
        ),
      ),
    );
  }
}
