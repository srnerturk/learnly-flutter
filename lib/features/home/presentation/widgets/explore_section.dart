import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/learning_item.dart';

const _categoryColors = {
  'Teknoloji': Color(0xFF00CFFF),
  'Tarih': Color(0xFFFF7A00),
  'Bilim': Color(0xFF00E676),
  'Dil': Color(0xFFFFCC00),
  'İş Dünyası': Color(0xFFFF4757),
  'Sanat': Color(0xFFFF6BCE),
};

class ExploreSection extends StatelessWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('Keşfet', style: AppTextStyles.titleLarge),
              const Gap(8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'Herkese Açık',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Tümünü Gör →',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const Gap(14),
        ...MockData.publicItems.map(
          (item) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: _PublicCard(item: item),
          ),
        ),
      ],
    );
  }
}

class _PublicCard extends StatelessWidget {
  final LearningItem item;

  const _PublicCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColors[item.category] ?? AppColors.textTertiary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: catColor,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      item.title,
                      style: AppTextStyles.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Gap(10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.bookmark_border_rounded,
                      color: AppColors.textSecondary, size: 18),
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              // Author
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.authorHandle![0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
              const Gap(6),
              Text(
                '@${item.authorHandle}',
                style: AppTextStyles.bodySmall,
              ),
              const Gap(10),
              const Icon(Icons.people_outline_rounded,
                  size: 13, color: AppColors.textTertiary),
              const Gap(4),
              Text(
                '${item.learnerCount} öğrenci',
                style: AppTextStyles.bodySmall,
              ),
              const Spacer(),
              ...item.typeIconList.map(
                (ic) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(ic, size: 14, color: AppColors.textTertiary),
                ),
              ),
            ],
          ),
          const Gap(12),
          // Start button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Çalışmaya Başla →',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 14,
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
