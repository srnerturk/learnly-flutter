import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/create_session.dart';
import '../providers/create_session_provider.dart';
import 'generation_screen.dart';
import 'steps/content_type_step.dart';
import 'steps/input_method_step.dart';
import 'steps/voice_selection_step.dart';

void showCreateBottomSheet(BuildContext context, {InputMethod? initialMethod}) {
  final container = ProviderScope.containerOf(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: CreateBottomSheet(initialMethod: initialMethod),
    ),
  );
}

class CreateBottomSheet extends ConsumerStatefulWidget {
  final InputMethod? initialMethod;
  const CreateBottomSheet({super.key, this.initialMethod});

  @override
  ConsumerState<CreateBottomSheet> createState() => _CreateBottomSheetState();
}

class _CreateBottomSheetState extends ConsumerState<CreateBottomSheet> {
  int _step = 0;
  bool _forward = true;

  static const _stepTitles = ['Kaynak', 'İçerik', 'Ses'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createSessionProvider.notifier).reset();
      if (widget.initialMethod != null) {
        ref
            .read(createSessionProvider.notifier)
            .setInputMethod(widget.initialMethod!);
      }
    });
  }

  bool _canProceed(CreateSession session) {
    switch (_step) {
      case 0:
        return session.isInputMethodValid;
      case 1:
        return session.isContentTypesValid;
      case 2:
        return session.isVoiceValid;
      default:
        return true;
    }
  }

  void _next() {
    final session = ref.read(createSessionProvider);
    if (_step == 1 && !session.hasAudioSummary) {
      _generate();
      return;
    }
    if (_step < 2) {
      setState(() {
        _forward = true;
        _step++;
      });
    } else {
      _generate();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() {
        _forward = false;
        _step--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _generate() {
    final session = ref.read(createSessionProvider);
    Navigator.of(context).pop();
    // TODO: paywall check before generation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showGenerationScreen(context, session);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(createSessionProvider);
    final canProceed = _canProceed(session);
    final totalSteps = session.hasAudioSummary ? 3 : 2;

    return Container(
      height: MediaQuery.of(context).size.height * 0.91,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _SheetHandle(),
          _SheetHeader(
            step: _step,
            totalSteps: totalSteps,
            stepTitles: _stepTitles,
            onClose: () => Navigator.of(context).pop(),
          ),
          _StepIndicator(
            currentStep: _step,
            totalSteps: totalSteps,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) {
                final begin =
                    _forward ? const Offset(0.12, 0) : const Offset(-0.12, 0);
                final offsetAnimation = Tween<Offset>(
                  begin: begin,
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ));
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              child: _buildCurrentStep(),
            ),
          ),
          _BottomBar(
            step: _step,
            canProceed: canProceed,
            isLastStep: _step == totalSteps - 1,
            onBack: _back,
            onNext: _next,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return const InputMethodStep(key: ValueKey(0));
      case 1:
        return const ContentTypeStep(key: ValueKey(1));
      case 2:
        return const VoiceSelectionStep(key: ValueKey(2));
      default:
        return const SizedBox.shrink();
    }
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final int step;
  final int totalSteps;
  final List<String> stepTitles;
  final VoidCallback onClose;

  const _SheetHeader({
    required this.step,
    required this.totalSteps,
    required this.stepTitles,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 0),
      child: Row(
        children: [
          Text(
            'Adım ${step + 1}/$totalSteps',
            style: AppTextStyles.labelMedium,
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textSecondary,
            iconSize: 22,
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isPast = index < currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                decoration: BoxDecoration(
                  color: isActive || isPast
                      ? AppColors.primary
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int step;
  final bool canProceed;
  final bool isLastStep;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _BottomBar({
    required this.step,
    required this.canProceed,
    required this.isLastStep,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12 + bottomPadding),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          if (step > 0)
            OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Geri'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            )
          else
            const SizedBox(width: 8),
          const Spacer(),
          FilledButton.icon(
            onPressed: canProceed ? onNext : null,
            icon: Icon(
              isLastStep
                  ? Icons.auto_awesome_rounded
                  : Icons.arrow_forward_rounded,
              size: 18,
            ),
            label: Text(isLastStep ? 'Oluştur' : 'Devam Et'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.border,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: AppTextStyles.labelLarge
                  .copyWith(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
