import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/data/mock_data.dart';
import '../../explore/presentation/screens/content_detail_screen.dart';

void showSearchOverlay(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondary) => const SearchOverlay(),
      transitionsBuilder: (context, anim, secondary, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
    ),
  );
}

const _recentSearches = ['Yapay Zeka', 'Kuantum Fiziği', 'Osmanlı Tarihi'];

const _suggestions = [
  (Icons.psychology_rounded, 'Makine Öğrenmesi'),
  (Icons.science_rounded, 'DNA ve Genetik'),
  (Icons.trending_up_rounded, 'Borsa Temelleri'),
  (Icons.map_rounded, 'İpek Yolu Tarihi'),
  (Icons.psychology_alt_rounded, 'Nörobilim'),
  (Icons.bolt_rounded, 'Yenilenebilir Enerji'),
];

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _dismiss() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final results = _query.isEmpty
        ? []
        : MockData.publicItems
            .where((item) =>
                item.title.toLowerCase().contains(_query.toLowerCase()) ||
                item.category.toLowerCase().contains(_query.toLowerCase()) ||
                (item.authorHandle ?? '')
                    .toLowerCase()
                    .contains(_query.toLowerCase()))
            .toList();

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blurred dimmed background — tap to dismiss
          GestureDetector(
            onTap: _dismiss,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                color: Colors.black.withValues(alpha: 0.72),
              ),
            ),
          ),

          // Search panel (slides down from top)
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 14),
                                child: Icon(Icons.search_rounded,
                                    color: AppColors.primary, size: 21),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  onChanged: (v) =>
                                      setState(() => _query = v),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textPrimary),
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Konu, kategori veya yazar ara...',
                                    filled: false,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                  ),
                                ),
                              ),
                              if (_query.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _controller.clear();
                                    setState(() => _query = '');
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 12),
                                    child: Icon(Icons.cancel_rounded,
                                        color: AppColors.textTertiary,
                                        size: 18),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: _dismiss,
                        child: Text(
                          'İptal',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .slideY(
                        begin: -0.4,
                        end: 0,
                        duration: 260.ms,
                        curve: Curves.easeOutCubic)
                    .fadeIn(duration: 200.ms),

                const Gap(12),

                // Results area
                Expanded(
                  child: _query.isEmpty
                      ? _EmptyState()
                          .animate()
                          .fadeIn(duration: 220.ms, delay: 80.ms)
                          .slideY(begin: 0.04, end: 0)
                      : _Results(
                          query: _query,
                          results: results,
                          onSelect: _dismiss,
                        ).animate().fadeIn(duration: 150.ms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state (recents + suggestions) ─────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Son Aramalar', style: AppTextStyles.titleSmall),
              Text('Temizle',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          const Gap(10),
          ..._recentSearches.asMap().entries.map(
                (e) => _RecentItem(label: e.value)
                    .animate(delay: Duration(milliseconds: 30 * e.key))
                    .fadeIn(duration: 200.ms)
                    .slideX(begin: 0.03, end: 0),
              ),
          const Gap(24),
          Text('Önerilen Konular', style: AppTextStyles.titleSmall),
          const Gap(12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions
                .asMap()
                .entries
                .map(
                  (e) => _SuggestionChip(
                    icon: e.value.$1,
                    label: e.value.$2,
                  )
                      .animate(delay: Duration(milliseconds: 30 * e.key))
                      .fadeIn(duration: 200.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final String label;
  const _RecentItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.history_rounded,
              color: AppColors.textTertiary, size: 17),
          const Gap(12),
          Expanded(
            child: Text(label,
                style: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textSecondary)),
          ),
          const Icon(Icons.north_west_rounded,
              color: AppColors.textTertiary, size: 14),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SuggestionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 15),
          const Gap(6),
          Text(label,
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── Search results ───────────────────────────────────────────────────────────

class _Results extends StatelessWidget {
  final String query;
  final List results;
  final VoidCallback onSelect;
  const _Results(
      {required this.query, required this.results, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                color: AppColors.textTertiary, size: 48),
            const Gap(12),
            Text('"$query" için sonuç bulunamadı',
                style: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length,
      separatorBuilder: (context, index) => const Divider(
        color: AppColors.border,
        height: 1,
        thickness: 1,
      ),
      itemBuilder: (context, i) {
        final item = results[i];
        return GestureDetector(
          onTap: () {
            onSelect();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ContentDetailScreen(item: item),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_stories_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HighlightText(
                          text: item.title, query: query),
                      const Gap(2),
                      Text(
                        '${item.category} · ${item.authorHandle ?? ''}',
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.textTertiary, size: 13),
              ],
            ),
          ),
        )
            .animate(delay: Duration(milliseconds: 25 * i))
            .fadeIn(duration: 180.ms)
            .slideX(begin: 0.03, end: 0);
      },
    );
  }
}

class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  const _HighlightText({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    final lower = text.toLowerCase();
    final qLower = query.toLowerCase();
    final idx = lower.indexOf(qLower);
    if (idx < 0) {
      return Text(text, style: AppTextStyles.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis);
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppTextStyles.bodyLarge,
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w800),
          ),
          TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
    );
  }
}
