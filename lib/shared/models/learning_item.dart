enum LearningItemType { audioSummary, flashcards, quiz, textSummary }

class LearningItem {
  final String id;
  final String title;
  final String category;
  final List<LearningItemType> types;
  final DateTime createdAt;
  final bool isPublic;
  final int? learnerCount;
  final String? authorHandle;

  const LearningItem({
    required this.id,
    required this.title,
    required this.category,
    required this.types,
    required this.createdAt,
    this.isPublic = false,
    this.learnerCount,
    this.authorHandle,
  });

  String get typeIcons => types.map((t) {
        switch (t) {
          case LearningItemType.audioSummary:
            return '🎧';
          case LearningItemType.flashcards:
            return '🃏';
          case LearningItemType.quiz:
            return '🧠';
          case LearningItemType.textSummary:
            return '📝';
        }
      }).join(' ');
}
