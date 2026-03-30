import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/learning_item.dart';

class TextSummaryTab extends StatelessWidget {
  final LearningItem item;
  const TextSummaryTab({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meta row
          Row(
            children: [
              _MetaBadge(icon: Icons.access_time_rounded, label: '4 dk okuma'),
              const Gap(8),
              _MetaBadge(icon: Icons.text_fields_rounded, label: '~520 kelime'),
            ],
          ),
          const Gap(24),
          _SummarySection(
            heading: 'Genel Bakış',
            emoji: '🔍',
            text:
                '${item.title}, günümüzde büyük önem taşıyan ve pek çok alanda etkisi görülen bir konudur. '
                'Bu özet, konunun temel kavramlarını, tarihsel gelişimini ve güncel yansımalarını kapsamaktadır. '
                'İçerik, anlaşılır bir dille ve önemli noktalar ön plana çıkarılarak hazırlanmıştır.',
          ),
          const Gap(20),
          _SummarySection(
            heading: 'Temel Kavramlar',
            emoji: '📌',
            text:
                'Bu konuyu anlamak için önce temel kavramları kavramak gerekmektedir. '
                'Her bir kavram, birbiriyle ilişkili ve bütünsel bir anlam taşımaktadır. '
                'Tanımlar doğru anlaşıldığında, daha derin analizler yapabilmek mümkün olur.',
          ),
          const Gap(20),
          _SummarySection(
            heading: 'Tarihsel Süreç',
            emoji: '⏳',
            text:
                'Konunun gelişim süreci incelendiğinde, önemli kırılma noktaları ve dönüm anları göze çarpmaktadır. '
                'Bu süreçte yaşanan değişimler, bugünkü anlayışımızı doğrudan şekillendirmiştir. '
                'Tarihsel perspektif, konuyu daha geniş bir çerçevede değerlendirmemizi sağlar.',
          ),
          const Gap(20),
          _SummarySection(
            heading: 'Güncel Önemi',
            emoji: '🌍',
            text:
                'Bugün bu konu, birçok sektörde ve gündelik hayatta karşımıza çıkmaktadır. '
                'Teknoloji, eğitim, sağlık ve ekonomi gibi alanlardaki etkileri giderek artmaktadır. '
                'Geleceğe yönelik projeksiyonlar, bu konunun önemini daha da artıracağına işaret etmektedir.',
          ),
          const Gap(28),
          _KeyTermsCard(),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textTertiary),
          const Gap(5),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  final String heading;
  final String emoji;
  final String text;

  const _SummarySection(
      {required this.heading, required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const Gap(8),
            Text(heading, style: AppTextStyles.titleSmall),
          ],
        ),
        const Gap(10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _KeyTermsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const terms = [
      ('Temel Kavram', 'Konunun merkezinde yer alan ana fikir'),
      ('İkincil Etken', 'Konuyu şekillendiren destekleyici unsur'),
      ('Kritik Nokta', 'Özellikle dikkat edilmesi gereken alan'),
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
              const Text('📚', style: TextStyle(fontSize: 16)),
              const Gap(8),
              Text('Anahtar Terimler', style: AppTextStyles.titleSmall),
            ],
          ),
          const Gap(12),
          ...terms.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.$1,
                        style: AppTextStyles.labelLarge
                            .copyWith(color: AppColors.primary)),
                    const Gap(3),
                    Text(t.$2, style: AppTextStyles.bodySmall),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
