import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/create_session.dart';

class CreateSessionNotifier extends Notifier<CreateSession> {
  @override
  CreateSession build() => const CreateSession();

  void setInputMethod(InputMethod method) {
    state = state.copyWith(inputMethod: method, inputContent: null);
  }

  void setInputContent(String content) {
    state = state.copyWith(inputContent: content);
  }

  void toggleContentType(ContentType type) {
    final updated = Set<ContentType>.from(state.contentTypes);
    if (updated.contains(type)) {
      updated.remove(type);
    } else {
      updated.add(type);
    }
    state = state.copyWith(contentTypes: updated);
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setVoice(String voiceId) {
    state = state.copyWith(voiceId: voiceId);
  }

  void reset() {
    state = const CreateSession();
  }
}

final createSessionProvider =
    NotifierProvider<CreateSessionNotifier, CreateSession>(
  CreateSessionNotifier.new,
);
