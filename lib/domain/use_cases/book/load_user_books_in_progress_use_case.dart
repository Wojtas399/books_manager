import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class LoadUserBooksInProgressUseCase {
  late final BookInterface _bookInterface;

  LoadUserBooksInProgressUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String userId}) async {
    await _bookInterface.loadUserBooks(
      userId: userId,
      bookStatus: BookStatus.inProgress,
    );
  }
}
