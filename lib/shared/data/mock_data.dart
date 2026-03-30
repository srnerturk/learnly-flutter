import 'package:flutter/material.dart';
import '../models/learning_item.dart';
import '../../features/create/models/create_session.dart';

abstract class MockData {
  static final List<LearningItem> recentItems = [
    LearningItem(
      id: '1',
      title: 'Makine Öğrenmesine Giriş',
      category: 'Teknoloji',
      types: [LearningItemType.flashcards, LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LearningItem(
      id: '2',
      title: '2. Dünya Savaşı',
      category: 'Tarih',
      types: [LearningItemType.audioSummary, LearningItemType.flashcards],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LearningItem(
      id: '3',
      title: 'Python Temelleri',
      category: 'Teknoloji',
      types: [LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    LearningItem(
      id: '4',
      title: 'Osmanlı İmparatorluğu',
      category: 'Tarih',
      types: [
        LearningItemType.audioSummary,
        LearningItemType.textSummary,
        LearningItemType.quiz
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final List<LearningItem> publicItems = [
    LearningItem(
      id: 'p1',
      title: 'Kuantum Fiziğine Giriş',
      category: 'Bilim',
      types: [LearningItemType.audioSummary, LearningItemType.flashcards, LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isPublic: true,
      learnerCount: 234,
      authorHandle: 'physics_fan',
    ),
    LearningItem(
      id: 'p2',
      title: 'Shakespeare\'in Eserleri',
      category: 'Sanat',
      types: [LearningItemType.audioSummary, LearningItemType.quiz, LearningItemType.textSummary],
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      isPublic: true,
      learnerCount: 189,
      authorHandle: 'literature_lover',
    ),
    LearningItem(
      id: 'p3',
      title: 'Blockchain Teknolojisi',
      category: 'Teknoloji',
      types: [LearningItemType.audioSummary, LearningItemType.flashcards, LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isPublic: true,
      learnerCount: 412,
      authorHandle: 'crypto_edu',
    ),
    LearningItem(
      id: 'p4',
      title: 'İnsan Vücudunun Sistemleri',
      category: 'Bilim',
      types: [LearningItemType.textSummary, LearningItemType.flashcards, LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isPublic: true,
      learnerCount: 301,
      authorHandle: 'bio_nerd',
    ),
    LearningItem(
      id: 'p5',
      title: 'Birinci Dünya Savaşı\'nın Sebepleri',
      category: 'Tarih',
      types: [LearningItemType.audioSummary, LearningItemType.textSummary],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isPublic: true,
      learnerCount: 175,
      authorHandle: 'history_buff',
    ),
    LearningItem(
      id: 'p6',
      title: 'Girişimcilik ve Startup Kültürü',
      category: 'İş Dünyası',
      types: [LearningItemType.audioSummary, LearningItemType.flashcards],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isPublic: true,
      learnerCount: 528,
      authorHandle: 'startup_guru',
    ),
    LearningItem(
      id: 'p7',
      title: 'Modern Sanat Akımları',
      category: 'Sanat',
      types: [LearningItemType.textSummary, LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      isPublic: true,
      learnerCount: 93,
      authorHandle: 'art_lover',
    ),
    LearningItem(
      id: 'p8',
      title: 'Yapay Zeka ve Etik',
      category: 'Teknoloji',
      types: [LearningItemType.audioSummary, LearningItemType.textSummary, LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isPublic: true,
      learnerCount: 644,
      authorHandle: 'ai_thinker',
    ),
    LearningItem(
      id: 'p9',
      title: 'İspanyolca: Temel İfadeler',
      category: 'Dil',
      types: [LearningItemType.audioSummary, LearningItemType.flashcards],
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isPublic: true,
      learnerCount: 387,
      authorHandle: 'polyglot',
    ),
    LearningItem(
      id: 'p10',
      title: 'Fotoğrafçılığa Giriş',
      category: 'Kişisel Gelişim',
      types: [LearningItemType.textSummary, LearningItemType.quiz],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isPublic: true,
      learnerCount: 212,
      authorHandle: 'lens_master',
    ),
  ];

  static const List<VoiceOption> voices = [
    VoiceOption(id: 'aria', name: 'Aria', description: 'Profesyonel & Net', gender: 'Kadın', icon: Icons.person_rounded),
    VoiceOption(id: 'nova', name: 'Nova', description: 'Sıcak & Samimi', gender: 'Kadın', icon: Icons.person_2_rounded),
    VoiceOption(id: 'marcus', name: 'Marcus', description: 'Derin & Güvenilir', gender: 'Erkek', icon: Icons.mic_rounded),
    VoiceOption(id: 'liam', name: 'Liam', description: 'Enerjik & Dinamik', gender: 'Erkek', icon: Icons.bolt_rounded),
    VoiceOption(id: 'zara', name: 'Zara', description: 'Çarpıcı & Akıcı', gender: 'Kadın', icon: Icons.auto_awesome_rounded, isPro: true),
    VoiceOption(id: 'atlas', name: 'Atlas', description: 'Dramatik & Etkileyici', gender: 'Erkek', icon: Icons.language_rounded, isPro: true),
  ];

  static const List<String> categories = [
    'Genel', 'Bilim', 'Tarih', 'Dil',
    'Teknoloji', 'İş Dünyası', 'Sanat', 'Kişisel Gelişim',
  ];
}
