import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/widgets/pro_badge.dart';
import '../../models/create_session.dart';
import '../../providers/create_session_provider.dart';

final _previewingVoiceProvider = StateProvider<String?>((ref) => null);

class VoiceSelectionStep extends ConsumerWidget {
  const VoiceSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(createSessionProvider);
    final previewingId = ref.watch(_previewingVoiceProvider);
    final notifier = ref.read(createSessionProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ses Seç', style: AppTextStyles.displayMedium),
          const Gap(6),
          Text('Sesli özetini okuyacak sesi seç', style: AppTextStyles.bodyMedium),
          const Gap(24),
          ...MockData.voices.map((voice) {
            final selected = session.voiceId == voice.id;
            final isPreviewing = previewingId == voice.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _VoiceTile(
                voice: voice,
                selected: selected,
                isPreviewing: isPreviewing,
                onTap: () => notifier.setVoice(voice.id),
                onPreview: () {
                  final pNotifier = ref.read(_previewingVoiceProvider.notifier);
                  if (isPreviewing) {
                    pNotifier.state = null;
                  } else {
                    pNotifier.state = voice.id;
                    Future.delayed(const Duration(seconds: 3), () {
                      if (ref.read(_previewingVoiceProvider) == voice.id) {
                        pNotifier.state = null;
                      }
                    });
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _VoiceTile extends StatelessWidget {
  final VoiceOption voice;
  final bool selected;
  final bool isPreviewing;
  final VoidCallback onTap;
  final VoidCallback onPreview;

  const _VoiceTile({
    required this.voice,
    required this.selected,
    required this.isPreviewing,
    required this.onTap,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  voice.icon,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(voice.name, style: AppTextStyles.titleSmall),
                      const Gap(6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          voice.gender,
                          style: AppTextStyles.labelSmall,
                        ),
                      ),
                      if (voice.isPro) ...[
                        const Gap(6),
                        const ProBadge(),
                      ],
                    ],
                  ),
                  const Gap(2),
                  Text(voice.description, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Gap(8),
            _PreviewButton(
              isPreviewing: isPreviewing,
              onTap: onPreview,
            ),
            const Gap(8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  final bool isPreviewing;
  final VoidCallback onTap;

  const _PreviewButton({required this.isPreviewing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isPreviewing
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: isPreviewing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => _Bar(index: i),
                ),
              )
            : const Icon(Icons.play_arrow_rounded,
                color: AppColors.primary, size: 18),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final int index;
  const _Bar({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleY(
          begin: 0.3,
          end: 1,
          duration: Duration(milliseconds: 300 + index * 80),
          curve: Curves.easeInOut,
        );
  }
}
