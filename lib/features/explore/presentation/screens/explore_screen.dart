import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/learning_item.dart';
import 'content_detail_screen.dart';

const _categoryIcons = {
  'Teknoloji': Icons.computer_rounded,
  'Tarih': Icons.history_edu_rounded,
  'Bilim': Icons.science_rounded,
  'Dil': Icons.translate_rounded,
  'İş Dünyası': Icons.business_center_rounded,
  'Sanat': Icons.palette_rounded,
  'Kişisel Gelişim': Icons.trending_up_rounded,
};

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'Tümü';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LearningItem> get _filtered {
    var items = MockData.publicItems;
    if (_selectedCategory != 'Tümü') {
      items = items.where((i) => i.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((i) =>
              i.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              i.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchBar(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
              ).animate().fadeIn(duration: 300.ms),
              const Gap(14),
              _CategoryFilterBar(
                selected: _selectedCategory,
                onSelect: (c) => setState(() => _selectedCategory = c),
              ).animate().fadeIn(duration: 300.ms, delay: 60.ms),
              const Gap(14),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  '${_filtered.length} içerik bulundu',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          sliver: SliverList.separated(
            itemCount: _filtered.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, i) => ExploreItemCard(
              item: _filtered[i],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ContentDetailScreen(item: _filtered[i]),
                ),
              ),
            )
                .animate(delay: Duration(milliseconds: i * 40))
                .fadeIn(duration: 280.ms)
                .slideY(begin: 0.05, end: 0),
          ),
        ),
      ],
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Konu, kategori ara...',
            hintStyle: AppTextStyles.bodyMedium,
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColors.textTertiary, size: 20),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}

// ─── Category Filter ──────────────────────────────────────────────────────────

class _CategoryFilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategoryFilterBar(
      {required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final all = ['Tümü', ...MockData.categories.where((c) => c != 'Genel')];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: all.length,
        separatorBuilder: (context, index) => const Gap(8),
        itemBuilder: (context, i) {
          final cat = all[i];
          final isSelected = selected == cat;
          return GestureDetector(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  if (cat != 'Tümü' && _categoryIcons[cat] != null)
                    Icon(
                      _categoryIcons[cat],
                      size: 13,
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textSecondary,
                    ),
                  if (cat != 'Tümü') const Gap(5),
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Item Card ────────────────────────────────────────────────────────────────

class ExploreItemCard extends StatelessWidget {
  final LearningItem item;
  final VoidCallback onTap;

  const ExploreItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CategoryChip(label: item.category),
                  const Gap(6),
                  Icon(
                    _categoryIcons[item.category] ?? Icons.auto_stories_rounded,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
              const Gap(8),
              Text(
                item.title,
                style: AppTextStyles.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(12),
              Row(
                children: [
                  _AuthorChip(handle: item.authorHandle ?? ''),
                  const Gap(10),
                  const Icon(Icons.people_outline_rounded,
                      size: 13, color: AppColors.textTertiary),
                  const Gap(4),
                  Text('${item.learnerCount}', style: AppTextStyles.bodySmall),
                  const Spacer(),
                  ...item.types.map((t) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: _TypeBadge(type: t),
                      )),
                ],
              ),
              const Gap(14),
              _StartButton(onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primary),
      ),
    );
  }
}

class _AuthorChip extends StatelessWidget {
  final String handle;
  const _AuthorChip({required this.handle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: AppColors.primaryGradient),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              handle.isNotEmpty ? handle[0].toUpperCase() : '?',
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.background),
            ),
          ),
        ),
        const Gap(5),
        Text('@$handle', style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final LearningItemType type;
  const _TypeBadge({required this.type});

  IconData get _icon {
    switch (type) {
      case LearningItemType.audioSummary: return Icons.headphones_rounded;
      case LearningItemType.flashcards: return Icons.style_rounded;
      case LearningItemType.quiz: return Icons.quiz_rounded;
      case LearningItemType.textSummary: return Icons.article_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Icon(_icon, color: AppColors.textTertiary, size: 14),
      ),
    );
  }
}


class _StartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Çalışmaya Başla',
                style: TextStyle(
                    color: AppColors.background,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
            Gap(6),
            Icon(Icons.arrow_forward_rounded,
                color: AppColors.background, size: 16),
          ],
        ),
      ),
    );
  }
}
