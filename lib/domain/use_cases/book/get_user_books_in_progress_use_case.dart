import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class GetUserBooksInProgressUseCase {
  late final BookInterface _bookInterface;

  GetUserBooksInProgressUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Stream<List<Book>?> execute({required String userId}) {
    return _bookInterface.getUserBooks(
      userId: userId,
      bookStatus: BookStatus.inProgress,
    );
  }
}
