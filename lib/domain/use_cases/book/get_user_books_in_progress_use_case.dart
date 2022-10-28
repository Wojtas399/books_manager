import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class GetUserBooksInProgressUseCase {
  late final BookInterface _bookInterface;

  GetUserBooksInProgressUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Stream<List<Book>?> execute({required String userId}) {
    return Stream.value([]);
    // return _bookInterface
    //     .getBooksByUserId(userId: userId)
    //     .map(_selectBooksInProgress);
  }

  // List<Book>? _selectBooksInProgress(List<Book>? books) {
  //   return books
  //       ?.where((Book book) => book.status == BookStatus.inProgress)
  //       .toList();
  // }
}
