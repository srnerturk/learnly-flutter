import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/learning_item.dart';

const _mockQuestions = [
  (
    question: 'Bu konunun ortaya çıkmasında en etkili faktör hangisidir?',
    options: ['Teknolojik gelişmeler', 'Sosyal değişimler', 'Ekonomik baskılar', 'Siyasi kararlar'],
    correct: 0,
  ),
  (
    question: 'Aşağıdakilerden hangisi bu alanın temel ilkeleri arasında yer almaz?',
    options: ['Sistematik yaklaşım', 'Rastlantısallık', 'Kanıta dayalı analiz', 'Sürekli gelişim'],
    correct: 1,
  ),
  (
    question: 'Bu konunun günümüzdeki en önemli uygulama alanı hangisidir?',
    options: ['Tıp ve sağlık', 'Eğitim teknolojileri', 'Enerji sektörü', 'Tarım endüstrisi'],
    correct: 1,
  ),
  (
    question: 'Tarihin hangi döneminde bu konu özellikle ön plana çıkmıştır?',
    options: ['Antik çağ', '18. yüzyıl', '20. yüzyıl başları', 'Dijital çağ'],
    correct: 3,
  ),
  (
    question: 'Bu alanda öncü olan araştırmacıların çalışmaları öncelikle neyi hedeflemiştir?',
    options: ['Teorik çerçeve oluşturma', 'Pratik uygulamalar geliştirme', 'Mevcut paradigmayı eleştirme', 'Hepsini birleştirme'],
    correct: 0,
  ),
];

enum _QuizState { answering, result }

class QuizTab extends StatefulWidget {
  final LearningItem item;
  const QuizTab({super.key, required this.item});

  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  int _qIndex = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  _QuizState _state = _QuizState.answering;

  void _select(int optIdx) {
    if (_answered) return;
    final correct = _mockQuestions[_qIndex].correct == optIdx;
    setState(() {
      _selected = optIdx;
      _answered = true;
      if (correct) _score++;
    });
  }

  void _next() {
    if (_qIndex == _mockQuestions.length - 1) {
      setState(() => _state = _QuizState.result);
    } else {
      setState(() {
        _qIndex++;
        _selected = null;
        _answered = false;
      });
    }
  }

  void _restart() {
    setState(() {
      _qIndex = 0;
      _selected = null;
      _answered = false;
      _score = 0;
      _state = _QuizState.answering;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _QuizState.result) {
      return _ResultScreen(
        score: _score,
        total: _mockQuestions.length,
        onRestart: _restart,
      );
    }

    final q = _mockQuestions[_qIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuizProgressBar(current: _qIndex + 1, total: _mockQuestions.length, score: _score),
          const Gap(24),
          _QuestionCard(
            number: _qIndex + 1,
            question: q.question,
          ).animate(key: ValueKey(_qIndex)).fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0),
          const Gap(20),
          ...List.generate(q.options.length, (i) {
            final isCorrect = i == q.correct;
            final isSelected = _selected == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionTile(
                label: q.options[i],
                index: i,
                state: !_answered
                    ? _OptionState.idle
                    : isCorrect
                        ? _OptionState.correct
                        : isSelected
                            ? _OptionState.wrong
                            : _OptionState.idle,
                onTap: () => _select(i),
              ).animate(delay: Duration(milliseconds: 60 * i))
                  .fadeIn(duration: 220.ms)
                  .slideY(begin: 0.06, end: 0),
            );
          }),
          if (_answered) ...[
            const Gap(12),
            _FeedbackBanner(isCorrect: _selected == q.correct),
            const Gap(16),
            _NextButton(
              isLast: _qIndex == _mockQuestions.length - 1,
              onTap: _next,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final int score;

  const _QuizProgressBar(
      {required this.current, required this.total, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Soru $current / $total', style: AppTextStyles.labelMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('$score doğru',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success)),
            ),
          ],
        ),
        const Gap(8),
        Row(
          children: List.generate(total, (i) {
            final done = i < current - 1;
            final active = i == current - 1;
            return Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 5,
                  decoration: BoxDecoration(
                    color: done
                        ? AppColors.success
                        : active
                            ? AppColors.primary
                            : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 6,
                            )
                          ]
                        : null,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int number;
  final String question;

  const _QuestionCard({required this.number, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              'SORU $number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          const Gap(12),
          Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

enum _OptionState { idle, correct, wrong }

class _OptionTile extends StatelessWidget {
  final String label;
  final int index;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.index,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final letters = ['A', 'B', 'C', 'D'];
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final Color letterBg;

    switch (state) {
      case _OptionState.correct:
        bgColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        letterBg = AppColors.success;
      case _OptionState.wrong:
        bgColor = AppColors.error.withValues(alpha: 0.1);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        letterBg = AppColors.error;
      case _OptionState.idle:
        bgColor = AppColors.surfaceVariant;
        borderColor = AppColors.border;
        textColor = AppColors.textPrimary;
        letterBg = AppColors.surfaceElevated;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: letterBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  letters[index],
                  style: TextStyle(
                    color: state == _OptionState.idle
                        ? AppColors.textSecondary
                        : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (state == _OptionState.correct)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 20),
            if (state == _OptionState.wrong)
              const Icon(Icons.cancel_rounded,
                  color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  const _FeedbackBanner({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: (isCorrect ? AppColors.success : AppColors.error)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isCorrect ? AppColors.success : AppColors.error)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(isCorrect ? '🎉' : '😕', style: const TextStyle(fontSize: 20)),
          const Gap(10),
          Text(
            isCorrect ? 'Harika! Doğru cevap!' : 'Maalesef, yanlış cevap.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isCorrect ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _NextButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onTap;

  const _NextButton({required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          isLast ? 'Sonuçları Gör 🏆' : 'Sonraki Soru →',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.background,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const _ResultScreen(
      {required this.score, required this.total, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    final pct = (score / total * 100).round();
    final isGood = pct >= 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Gap(20),
          Text(isGood ? '🏆' : '💪',
              style: const TextStyle(fontSize: 64))
              .animate()
              .scale(begin: const Offset(0.5, 0.5), duration: 400.ms, curve: Curves.elasticOut),
          const Gap(16),
          Text(
            isGood ? 'Mükemmel!' : 'Devam Et!',
            style: AppTextStyles.displayMedium,
          ),
          const Gap(8),
          Text(
            isGood
                ? 'Konuya hakim olduğunu gösterdin.'
                : 'Tekrar çalışarak daha iyi yapabilirsin.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Gap(32),
          // Score circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isGood
                    ? [AppColors.success, const Color(0xFF00B09B)]
                    : [AppColors.accent, const Color(0xFFFF4500)],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isGood ? AppColors.success : AppColors.accent)
                      .withValues(alpha: 0.4),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$pct%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$score / $total doğru',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .scale(begin: const Offset(0.6, 0.6), duration: 500.ms, curve: Curves.elasticOut),
          const Gap(40),
          GestureDetector(
            onTap: onRestart,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                '🔄 Tekrar Dene',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
