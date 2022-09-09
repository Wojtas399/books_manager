import 'package:app/domain/interfaces/book_interface.dart';

class DeleteBookUseCase {
  late final BookInterface _bookInterface;

  DeleteBookUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String userId,
    required String bookId,
  }) async {
    await _bookInterface.deleteBook(userId: userId, bookId: bookId);
  }
}
