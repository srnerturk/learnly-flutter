import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/learning_item.dart';

class AudioPlayerTab extends StatefulWidget {
  final LearningItem item;
  const AudioPlayerTab({super.key, required this.item});

  @override
  State<AudioPlayerTab> createState() => _AudioPlayerTabState();
}

class _AudioPlayerTabState extends State<AudioPlayerTab>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.31;
  String _speed = '1x';

  static const _speeds = ['0.5x', '0.75x', '1x', '1.25x', '1.5x', '2x'];

  String get _elapsed => _formatTime((_progress * 348).round());
  String get _total => '5:48';

  String _formatTime(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Waveform
          _Waveform(isPlaying: _isPlaying, progress: _progress)
              .animate()
              .fadeIn(duration: 400.ms),
          const Gap(28),
          // Title
          Text(
            widget.item.title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          const Gap(6),
          Text('Sesli Özet · Aria',
              style: AppTextStyles.bodyMedium),
          const Gap(28),
          // Progress bar
          _ProgressBar(
            progress: _progress,
            elapsed: _elapsed,
            total: _total,
            onChanged: (v) => setState(() => _progress = v),
          ),
          const Gap(24),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ControlBtn(
                icon: Icons.replay_10_rounded,
                size: 36,
                onTap: () => setState(
                    () => _progress = (_progress - 0.05).clamp(0, 1)),
              ),
              const Gap(20),
              _PlayPauseBtn(
                isPlaying: _isPlaying,
                onTap: () => setState(() => _isPlaying = !_isPlaying),
              ),
              const Gap(20),
              _ControlBtn(
                icon: Icons.forward_10_rounded,
                size: 36,
                onTap: () => setState(
                    () => _progress = (_progress + 0.05).clamp(0, 1)),
              ),
            ],
          ),
          const Gap(24),
          // Speed selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _speeds.map((s) {
              final sel = s == _speed;
              return GestureDetector(
                onTap: () => setState(() => _speed = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: sel ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: sel ? AppColors.background : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const Gap(32),
          // Key points
          _KeyPointsCard(),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  final bool isPlaying;
  final double progress;

  const _Waveform({required this.isPlaying, required this.progress});

  @override
  Widget build(BuildContext context) {
    const barCount = 48;
    final playedBars = (barCount * progress).round();
    final heights = List.generate(barCount, (i) {
      const pattern = [0.3, 0.6, 0.9, 0.5, 0.8, 0.4, 1.0, 0.6, 0.7, 0.3, 0.8, 0.5];
      return pattern[i % pattern.length];
    });

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(barCount, (i) {
          final played = i < playedBars;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 3,
            height: 60 * heights[i],
            decoration: BoxDecoration(
              color: played
                  ? AppColors.primary
                  : AppColors.border,
              borderRadius: BorderRadius.circular(2),
              boxShadow: played
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 4,
                      )
                    ]
                  : null,
            ),
          );
        }),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final String elapsed;
  final String total;
  final ValueChanged<double> onChanged;

  const _ProgressBar({
    required this.progress,
    required this.elapsed,
    required this.total,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.15),
          ),
          child: Slider(value: progress, onChanged: onChanged),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(elapsed, style: AppTextStyles.bodySmall),
              Text(total, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const _PlayPauseBtn({required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: AppColors.background,
          size: 32,
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  const _ControlBtn(
      {required this.icon, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.textSecondary, size: size),
    );
  }
}

class _KeyPointsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const points = [
      'Temel kavramlar net bir dille açıklandı',
      'Tarihsel bağlam ve gelişim süreci ele alındı',
      'Günümüzdeki etkileri ve uygulamaları tartışıldı',
      'Önemli isimler ve dönüm noktaları özetlendi',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded, color: AppColors.gold, size: 17),
              const Gap(8),
              Text('Öne Çıkan Noktalar', style: AppTextStyles.titleSmall),
            ],
          ),
          const Gap(12),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('·', style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                    const Gap(8),
                    Expanded(
                        child: Text(p,
                            style: AppTextStyles.bodyMedium
                                .copyWith(height: 1.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
