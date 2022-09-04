import 'package:app/interfaces/book_interface.dart';

class DeleteBookUseCase {
  late final BookInterface _bookInterface;

  DeleteBookUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String bookId}) async {
    await _bookInterface.deleteBook(bookId: bookId);
  }
}
