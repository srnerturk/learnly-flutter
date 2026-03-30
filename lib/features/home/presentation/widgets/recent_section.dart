import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/learning_item.dart';

const _categoryMeta = {
  'Teknoloji': (color: Color(0xFF00CFFF), emoji: '💻'),
  'Tarih': (color: Color(0xFFFF7A00), emoji: '📜'),
  'Bilim': (color: Color(0xFF00E676), emoji: '🔬'),
  'Dil': (color: Color(0xFFFFCC00), emoji: '💬'),
  'İş Dünyası': (color: Color(0xFFFF4757), emoji: '💼'),
  'Sanat': (color: Color(0xFFFF6BCE), emoji: '🎨'),
};

class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('Son Çalışmalar', style: AppTextStyles.titleLarge),
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
        ...MockData.recentItems.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _RecentItemCard(item: e.value, xpEarned: 40 + e.key * 15),
            )),
      ],
    );
  }
}

class _RecentItemCard extends StatelessWidget {
  final LearningItem item;
  final int xpEarned;

  const _RecentItemCard({required this.item, required this.xpEarned});

  String _timeAgo() {
    final diff = DateTime.now().difference(item.createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} sa önce';
    if (diff.inDays == 1) return 'Dün';
    return '${diff.inDays} gün önce';
  }

  @override
  Widget build(BuildContext context) {
    final meta = _categoryMeta[item.category] ??
        (color: AppColors.textTertiary, emoji: '📚');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: meta.color.withValues(alpha: 0.25),
              ),
            ),
            child: Center(
              child: Text(meta.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const Gap(12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(5),
                Row(
                  children: [
                    _CategoryTag(
                      label: item.category,
                      color: meta.color,
                    ),
                    const Gap(6),
                    Text(
                      item.typeIcons,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(8),
          // Right side: time + XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _XpTag(xp: xpEarned),
              const Gap(4),
              Text(_timeAgo(), style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _XpTag extends StatelessWidget {
  final int xp;
  const _XpTag({required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⚡', style: TextStyle(fontSize: 10)),
          const Gap(3),
          Text(
            '+$xp XP',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}
