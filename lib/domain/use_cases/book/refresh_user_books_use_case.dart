import '../../../interfaces/book_interface.dart';

class RefreshUserBooksUseCase {
  late final BookInterface _bookInterface;

  RefreshUserBooksUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String userId}) async {
    await _bookInterface.refreshUserBooks(userId: userId);
  }
}
