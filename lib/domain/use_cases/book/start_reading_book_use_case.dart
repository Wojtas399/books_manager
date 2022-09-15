import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class StartReadingBookUseCase {
  late final BookInterface _bookInterface;

  StartReadingBookUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String bookId,
    required String userId,
  }) async {
    await _bookInterface.updateBookData(
      bookId: bookId,
      userId: userId,
      bookStatus: BookStatus.inProgress,
    );
  }
}
