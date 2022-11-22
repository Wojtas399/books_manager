import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class GetBooksInProgressOfUserUseCase {
  late final BookInterface _bookInterface;

  GetBooksInProgressOfUserUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Stream<List<Book>?> execute({required String userId}) {
    return _bookInterface.getBooksOfUser(
      userId: userId,
      bookStatus: BookStatus.inProgress,
    );
  }
}
