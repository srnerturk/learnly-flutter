import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/learning_item.dart';
import '../widgets/audio_player_tab.dart';
import '../widgets/flashcards_tab.dart';
import '../widgets/quiz_tab.dart';
import '../widgets/text_summary_tab.dart';

const _categoryColors = {
  'Teknoloji': Color(0xFF00CFFF),
  'Tarih': Color(0xFFFF7A00),
  'Bilim': Color(0xFF00E676),
  'Dil': Color(0xFFFFCC00),
  'İş Dünyası': Color(0xFFFF4757),
  'Sanat': Color(0xFFFF6BCE),
  'Kişisel Gelişim': Color(0xFFA78BFA),
};

const _categoryEmojis = {
  'Teknoloji': '💻', 'Tarih': '📜', 'Bilim': '🔬',
  'Dil': '💬', 'İş Dünyası': '💼', 'Sanat': '🎨', 'Kişisel Gelişim': '🚀',
};

class ContentDetailScreen extends StatefulWidget {
  final LearningItem item;
  const ContentDetailScreen({super.key, required this.item});

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.item.types.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catColor =
        _categoryColors[widget.item.category] ?? AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: _BackButton(),
            actions: const [_ShareButton(), Gap(12)],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _DetailHeader(
                item: widget.item,
                catColor: catColor,
              ),
            ),
            bottom: _TabBar(
              controller: _tabController,
              types: widget.item.types,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: widget.item.types.map(_buildTab).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(LearningItemType type) {
    switch (type) {
      case LearningItemType.audioSummary:
        return AudioPlayerTab(item: widget.item);
      case LearningItemType.textSummary:
        return TextSummaryTab(item: widget.item);
      case LearningItemType.flashcards:
        return FlashcardsTab(item: widget.item);
      case LearningItemType.quiz:
        return QuizTab(item: widget.item);
    }
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final LearningItem item;
  final Color catColor;

  const _DetailHeader({required this.item, required this.catColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            catColor.withValues(alpha: 0.9),
            catColor.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Large background emoji — bottom right
          Positioned(
            right: -8,
            bottom: 16,
            child: Opacity(
              opacity: 0.35,
              child: Text(
                _categoryEmojis[item.category] ?? '📚',
                style: const TextStyle(fontSize: 110),
              ),
            ),
          ),
          // Content — vertically centered in available space
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 72, 140, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(10),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(8),
                Row(
                  children: [
                    if (item.authorHandle != null) ...[
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item.authorHandle![0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const Gap(6),
                      Text(
                        '@${item.authorHandle}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(12),
                      const Icon(Icons.people_outline_rounded,
                          size: 13, color: Colors.white54),
                      const Gap(4),
                      Text(
                        '${item.learnerCount} öğrenci',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab Bar ──────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<LearningItemType> types;

  const _TabBar({required this.controller, required this.types});

  @override
  Size get preferredSize => const Size.fromHeight(48);

  String _emoji(LearningItemType t) {
    switch (t) {
      case LearningItemType.audioSummary: return '🎧';
      case LearningItemType.textSummary: return '📝';
      case LearningItemType.flashcards: return '🃏';
      case LearningItemType.quiz: return '🧠';
    }
  }

  String _label(LearningItemType t) {
    switch (t) {
      case LearningItemType.audioSummary: return 'Dinle';
      case LearningItemType.textSummary: return 'Oku';
      case LearningItemType.flashcards: return 'Kartlar';
      case LearningItemType.quiz: return 'Quiz';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: TabBar(
        controller: controller,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: AppTextStyles.labelMedium
            .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        tabs: types.map((t) => Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_emoji(t), style: const TextStyle(fontSize: 14)),
              const Gap(5),
              Text(_label(t)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 9),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.ios_share_rounded, color: Colors.white, size: 16),
            Gap(6),
            Text(
              'Paylaş',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

