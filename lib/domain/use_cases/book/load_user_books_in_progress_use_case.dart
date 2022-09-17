import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class LoadUserBooksInProgress {
  late final BookInterface _bookInterface;

  LoadUserBooksInProgress({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String userId}) async {
    await _bookInterface.loadUserBooks(
      userId: userId,
      bookStatus: BookStatus.inProgress,
    );
  }
}
