import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_document.dart';
import '../data/repositories/document_repository.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepository();
});

class DocumentsNotifier extends StateNotifier<List<UserDocument>> {
  DocumentsNotifier(this._repository) : super(_repository.cached);

  final DocumentRepository _repository;

  Future<void> validatePending() async {
    await _repository.validatePending();
    state = _repository.cached;
  }
}

final documentsProvider =
    StateNotifierProvider<DocumentsNotifier, List<UserDocument>>((ref) {
  return DocumentsNotifier(ref.watch(documentRepositoryProvider));
});
