import '../models/user_document.dart';
import '../services/mock_data.dart';

class DocumentRepository {
  DocumentRepository() : _items = List<UserDocument>.of(MockData.documents);

  final List<UserDocument> _items;

  List<UserDocument> get cached => List<UserDocument>.unmodifiable(_items);

  Future<void> validatePending() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    for (var index = 0; index < _items.length; index++) {
      if (_items[index].status == DocumentStatus.pending) {
        _items[index] = _items[index].copyWith(status: DocumentStatus.validated);
      }
    }
  }
}
