import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class GetBookUseCase {
  late final BookInterface _bookInterface;

  GetBookUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Stream<Book?> execute({
    required String bookId,
    required String userId,
  }) {
    return _bookInterface.getBook(bookId: bookId, userId: userId);
  }
}
