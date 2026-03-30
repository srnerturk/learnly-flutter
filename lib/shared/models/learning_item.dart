import 'package:flutter/material.dart';

enum LearningItemType { audioSummary, flashcards, quiz, textSummary }

extension LearningItemTypeIcon on LearningItemType {
  IconData get icon {
    switch (this) {
      case LearningItemType.audioSummary: return Icons.headphones_rounded;
      case LearningItemType.flashcards: return Icons.style_rounded;
      case LearningItemType.quiz: return Icons.quiz_rounded;
      case LearningItemType.textSummary: return Icons.article_rounded;
    }
  }
}

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

  List<IconData> get typeIconList => types.map((t) => t.icon).toList();
}
