import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/data/mock_data.dart';
import '../../models/create_session.dart';
import '../../providers/create_session_provider.dart';

const _typeColors = {
  ContentType.audioSummary: Color(0xFF00CFFF),
  ContentType.flashcards: Color(0xFFFF7A00),
  ContentType.quiz: Color(0xFF00E676),
  ContentType.textSummary: Color(0xFFFFCC00),
};

class ContentTypeStep extends ConsumerWidget {
  const ContentTypeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(createSessionProvider);
    final notifier = ref.read(createSessionProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ne Oluşturmak İstiyorsun?', style: AppTextStyles.displayMedium),
          const Gap(6),
          Text('Birden fazla seçebilirsin', style: AppTextStyles.bodyMedium),
          const Gap(24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: ContentType.values.map((type) {
              final selected = session.contentTypes.contains(type);
              final color = _typeColors[type]!;
              return _ContentTypeCard(
                type: type,
                color: color,
                selected: selected,
                onTap: () => notifier.toggleContentType(type),
              );
            }).toList(),
          ),
          const Gap(28),
          Text('Kategori', style: AppTextStyles.titleMedium),
          const Gap(12),
          _CategoryChips(
            selectedCategory: session.category,
            onCategorySelected: (cat) {
              final isAlreadySelected = session.category == cat;
              notifier.setCategory(isAlreadySelected ? null : cat);
            },
          ),
        ],
      ),
    );
  }
}

class _ContentTypeCard extends StatelessWidget {
  final ContentType type;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ContentTypeCard({
    required this.type,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.07) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type.emoji, style: const TextStyle(fontSize: 28)),
                if (selected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
              ],
            ),
            const Spacer(),
            Text(type.label, style: AppTextStyles.titleSmall),
            const Gap(2),
            Text(type.description, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _CategoryChips({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: MockData.categories.map((category) {
        final selected = selectedCategory == category;
        return GestureDetector(
          onTap: () => onCategorySelected(category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              category,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
