enum InputMethod { document, text, camera, gallery }

enum ContentType {
  audioSummary,
  flashcards,
  quiz,
  textSummary;

  String get label {
    switch (this) {
      case audioSummary:
        return 'Sesli Özet';
      case flashcards:
        return 'Çalışma Kartları';
      case quiz:
        return 'Quiz';
      case textSummary:
        return 'Metin Özet';
    }
  }

  String get description {
    switch (this) {
      case audioSummary:
        return 'Dinleyerek öğren';
      case flashcards:
        return 'Kartlarla tekrar et';
      case quiz:
        return 'Bilgini test et';
      case textSummary:
        return 'Hızlı oku';
    }
  }

  String get emoji {
    switch (this) {
      case audioSummary:
        return '🎧';
      case flashcards:
        return '🃏';
      case quiz:
        return '🧠';
      case textSummary:
        return '📝';
    }
  }
}

class VoiceOption {
  final String id;
  final String name;
  final String description;
  final String gender;
  final String emoji;
  final bool isPro;

  const VoiceOption({
    required this.id,
    required this.name,
    required this.description,
    required this.gender,
    required this.emoji,
    this.isPro = false,
  });
}

class CreateSession {
  final InputMethod? inputMethod;
  final String? inputContent;
  final Set<ContentType> contentTypes;
  final String? category;
  final String? voiceId;

  const CreateSession({
    this.inputMethod,
    this.inputContent,
    this.contentTypes = const {},
    this.category,
    this.voiceId,
  });

  bool get hasAudioSummary =>
      contentTypes.contains(ContentType.audioSummary);

  bool get isInputMethodValid => inputMethod != null;
  bool get isContentTypesValid => contentTypes.isNotEmpty;
  bool get isVoiceValid => voiceId != null;

  CreateSession copyWith({
    InputMethod? inputMethod,
    String? inputContent,
    Set<ContentType>? contentTypes,
    String? category,
    String? voiceId,
  }) {
    return CreateSession(
      inputMethod: inputMethod ?? this.inputMethod,
      inputContent: inputContent ?? this.inputContent,
      contentTypes: contentTypes ?? this.contentTypes,
      category: category ?? this.category,
      voiceId: voiceId ?? this.voiceId,
    );
  }
}
