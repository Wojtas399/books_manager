import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class GetBookByIdUseCase {
  late final BookInterface _bookInterface;

  GetBookByIdUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Stream<Book> execute({required String bookId}) {
    return _bookInterface.getBookById(bookId: bookId);
  }
}
