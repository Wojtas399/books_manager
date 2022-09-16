import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class GetUserBooksByStatusUseCase {
  late final BookInterface _bookInterface;

  GetUserBooksByStatusUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Stream<List<Book>> execute({
    required String userId,
    required BookStatus bookStatus,
  }) {
    return _bookInterface
        .getBooksByUserId(userId: userId)
        .map((List<Book> books) => _selectBooksByStatus(books, bookStatus));
  }

  List<Book> _selectBooksByStatus(
    List<Book> books,
    BookStatus status,
  ) {
    return books.where((Book book) => book.status == status).toList();
  }
}
