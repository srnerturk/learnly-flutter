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

const _swipeThreshold = 90.0;

class FlashcardsTab extends StatefulWidget {
  final LearningItem item;
  const FlashcardsTab({super.key, required this.item});

  @override
  State<FlashcardsTab> createState() => _FlashcardsTabState();
}

class _FlashcardsTabState extends State<FlashcardsTab>
    with TickerProviderStateMixin {
  int _index = 0;
  Offset _dragOffset = Offset.zero;
  bool _flipped = false;
  int _knowCount = 0;
  int _againCount = 0;

  // Flip animation
  late final AnimationController _flipCtrl;
  late final Animation<double> _flipAnim;

  // Snap / fly-off animation
  late final AnimationController _swipeCtrl;
  late Animation<Offset> _swipeAnim;
  bool _isAnimating = false;

  bool get _done => _index >= _mockCards.length;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _flipAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));

    _swipeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));
    _swipeAnim =
        Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_swipeCtrl);
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    _swipeCtrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isAnimating) return;
    if (_flipped) {
      _flipCtrl.reverse();
    } else {
      _flipCtrl.forward();
    }
    setState(() => _flipped = !_flipped);
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_isAnimating || _done) return;
    setState(() => _dragOffset += Offset(d.delta.dx, d.delta.dy * 0.25));
  }

  void _onPanEnd(DragEndDetails d) {
    if (_isAnimating || _done) return;
    final vel = d.velocity.pixelsPerSecond.dx;
    if (_dragOffset.dx.abs() > _swipeThreshold || vel.abs() > 500) {
      _flyOff(_dragOffset.dx > 0 || vel > 500);
    } else {
      _snapBack();
    }
  }

  void _snapBack() {
    _swipeAnim = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _swipeCtrl, curve: Curves.elasticOut),
    );
    _swipeCtrl.duration = const Duration(milliseconds: 500);
    _swipeCtrl.reset();
    _isAnimating = true;
    _swipeCtrl.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _dragOffset = Offset.zero;
        _isAnimating = false;
      });
    });
  }

  void _flyOff(bool toRight) {
    final target = Offset(toRight ? 600 : -600, _dragOffset.dy - 40);
    _swipeAnim = Tween<Offset>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeInCubic),
    );
    _swipeCtrl.duration = const Duration(milliseconds: 280);
    _swipeCtrl.reset();
    _isAnimating = true;
    setState(() {
      if (toRight) { _knowCount++; } else { _againCount++; }
    });
    _swipeCtrl.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _index++;
        _dragOffset = Offset.zero;
        _flipped = false;
        _isAnimating = false;
      });
      _flipCtrl.reset();
    });
  }

  // Programmatic swipe buttons
  void _swipeKnow() {
    if (_isAnimating || _done) return;
    setState(() => _dragOffset = const Offset(1, 0));
    _flyOff(true);
  }

  void _swipeAgain() {
    if (_isAnimating || _done) return;
    setState(() => _dragOffset = const Offset(-1, 0));
    _flyOff(false);
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return _DoneScreen(
        know: _knowCount,
        again: _againCount,
        total: _mockCards.length,
        onRestart: () => setState(() {
          _index = 0;
          _knowCount = 0;
          _againCount = 0;
          _flipCtrl.reset();
        }),
      );
    }

    final card = _mockCards[_index];
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          _ProgressRow(current: _index + 1, total: _mockCards.length),
          const Gap(20),

          // Swipe direction hints
          AnimatedBuilder(
            animation: _swipeCtrl,
            builder: (context, _) {
              final offset = _isAnimating ? _swipeAnim.value : _dragOffset;
              final knowOpacity = (offset.dx / 60).clamp(0.0, 1.0);
              final againOpacity = (-offset.dx / 60).clamp(0.0, 1.0);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DirectionLabel(
                      label: 'Tekrar',
                      color: AppColors.error,
                      icon: Icons.replay_rounded,
                      opacity: againOpacity),
                  _DirectionLabel(
                      label: 'Biliyorum',
                      color: AppColors.success,
                      icon: Icons.check_rounded,
                      opacity: knowOpacity),
                ],
              );
            },
          ),
          const Gap(10),

          // Card stack
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 3rd card (background depth)
                if (_index + 2 < _mockCards.length)
                  _BackCard(
                    text: _mockCards[_index + 2].$1,
                    scale: 0.86,
                    opacity: 0.3,
                    translateY: -14,
                  ),
                // 2nd card (middle depth)
                if (_index + 1 < _mockCards.length)
                  _BackCard(
                    text: _mockCards[_index + 1].$1,
                    scale: 0.93,
                    opacity: 0.55,
                    translateY: -7,
                  ),

                // Front card — draggable
                AnimatedBuilder(
                  animation: _swipeCtrl,
                  builder: (context, _) {
                    final offset =
                        _isAnimating ? _swipeAnim.value : _dragOffset;
                    final angle = (offset.dx / screenWidth) * 0.30;
                    final knowOp = (offset.dx / 55).clamp(0.0, 1.0);
                    final againOp = (-offset.dx / 55).clamp(0.0, 1.0);

                    return GestureDetector(
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      onTap: _flip,
                        child: Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()
                          ..translateByDouble(offset.dx, offset.dy, 0, 1)
                          ..rotateZ(angle),
                        child: AnimatedBuilder(
                          animation: _flipAnim,
                          builder: (context, _) {
                            final isBack = _flipAnim.value >= 0.5;
                            final flipAngle = _flipAnim.value * pi;
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(flipAngle),
                              child: isBack
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform:
                                          Matrix4.identity()..rotateY(pi),
                                      child: _CardFaceWithOverlay(
                                        text: card.$2,
                                        isBack: true,
                                        label: 'CEVAP',
                                        knowOpacity: knowOp,
                                        againOpacity: againOp,
                                      ),
                                    )
                                  : _CardFaceWithOverlay(
                                      text: card.$1,
                                      isBack: false,
                                      label: 'SORU',
                                      knowOpacity: knowOp,
                                      againOpacity: againOp,
                                    ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Gap(10),
          AnimatedSwitcher(
            duration: 200.ms,
            child: Text(
              key: ValueKey(_flipped),
              _flipped ? 'Dokunarak soruya dön' : 'Dokunarak cevabı gör',
              style: AppTextStyles.bodySmall,
            ),
          ),
          const Gap(28),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Tekrar',
                  icon: Icons.replay_rounded,
                  color: AppColors.error,
                  onTap: _swipeAgain,
                ),
              ),
              const Gap(14),
              Expanded(
                child: _ActionButton(
                  label: 'Biliyorum',
                  icon: Icons.check_rounded,
                  color: AppColors.success,
                  onTap: _swipeKnow,
                ),
              ),
            ],
          ),
          const Gap(24),
          _StatsBar(know: _knowCount, again: _againCount, remaining: _mockCards.length - _index),
        ],
      ),
    );
  }
}

// ─── Back card (depth stack) ──────────────────────────────────────────────────

class _BackCard extends StatelessWidget {
  final String text;
  final double scale;
  final double opacity;
  final double translateY;

  const _BackCard({
    required this.text,
    required this.scale,
    required this.opacity,
    required this.translateY,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: _CardFace(text: text, isBack: false, label: 'SORU'),
        ),
      ),
    );
  }
}

// ─── Card face ────────────────────────────────────────────────────────────────

class _CardFaceWithOverlay extends StatelessWidget {
  final String text;
  final bool isBack;
  final String label;
  final double knowOpacity;
  final double againOpacity;

  const _CardFaceWithOverlay({
    required this.text,
    required this.isBack,
    required this.label,
    required this.knowOpacity,
    required this.againOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CardFace(text: text, isBack: isBack, label: label),
        // Know overlay (right side glow)
        if (knowOpacity > 0.01)
          Positioned.fill(
            child: Opacity(
              opacity: knowOpacity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.success.withValues(alpha: 0.35),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
        // Again overlay (left side glow)
        if (againOpacity > 0.01)
          Positioned.fill(
            child: Opacity(
              opacity: againOpacity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.error.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
        // "BİLİYORUM" stamp
        if (knowOpacity > 0.15)
          Positioned(
            top: 18,
            right: 16,
            child: Opacity(
              opacity: knowOpacity,
              child: _SwipeStamp(
                  label: 'BİLİYORUM', color: AppColors.success),
            ),
          ),
        // "TEKRAR" stamp
        if (againOpacity > 0.15)
          Positioned(
            top: 18,
            left: 16,
            child: Opacity(
              opacity: againOpacity,
              child:
                  _SwipeStamp(label: 'TEKRAR', color: AppColors.error),
            ),
          ),
      ],
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
                .withValues(alpha: 0.32),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 16,
            child: Icon(
              isBack
                  ? Icons.check_circle_rounded
                  : Icons.help_outline_rounded,
              color: Colors.white.withValues(alpha: 0.35),
              size: 22,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Swipe stamp ──────────────────────────────────────────────────────────────

class _SwipeStamp extends StatelessWidget {
  final String label;
  final Color color;
  const _SwipeStamp({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// ─── Direction hint labels ────────────────────────────────────────────────────

class _DirectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final double opacity;

  const _DirectionLabel({
    required this.label,
    required this.color,
    required this.icon,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const Gap(4),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

// ─── Progress ─────────────────────────────────────────────────────────────────

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
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ─── Action buttons ───────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const Gap(7),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

// ─── Stats bar ────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  final int know;
  final int again;
  final int remaining;

  const _StatsBar(
      {required this.know, required this.again, required this.remaining});

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
          _Stat(
              label: 'Biliyorum',
              value: '$know',
              color: AppColors.success),
          _Stat(
              label: 'Tekrar',
              value: '$again',
              color: AppColors.error),
          _Stat(
              label: 'Kalan',
              value: '$remaining',
              color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({required this.label, required this.value, required this.color});

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

// ─── Done screen ──────────────────────────────────────────────────────────────

class _DoneScreen extends StatelessWidget {
  final int know;
  final int again;
  final int total;
  final VoidCallback onRestart;

  const _DoneScreen({
    required this.know,
    required this.again,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final pct = ((know / total) * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration_rounded,
                color: AppColors.primary, size: 64)
                .animate()
                .scale(begin: const Offset(0.5, 0.5), duration: 400.ms,
                    curve: Curves.elasticOut),
            const Gap(20),
            Text('Tebrikler!', style: AppTextStyles.displayMedium)
                .animate().fadeIn(delay: 150.ms),
            const Gap(8),
            Text(
              '$total kartın tamamını geçtin',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textSecondary),
            ).animate().fadeIn(delay: 200.ms),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultPill(label: 'Biliyorum', value: '$know', color: AppColors.success),
                const Gap(12),
                _ResultPill(label: 'Tekrar', value: '$again', color: AppColors.error),
                const Gap(12),
                _ResultPill(label: 'Oran', value: '%$pct', color: AppColors.primary),
              ],
            ).animate().fadeIn(delay: 280.ms),
            const Gap(36),
            GestureDetector(
              onTap: onRestart,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: AppColors.primaryGradient),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.replay_rounded,
                        color: AppColors.background, size: 18),
                    Gap(8),
                    Text('Yeniden Başla',
                        style: TextStyle(
                            color: AppColors.background,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }
}

class _ResultPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultPill(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: color)),
          const Gap(2),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
