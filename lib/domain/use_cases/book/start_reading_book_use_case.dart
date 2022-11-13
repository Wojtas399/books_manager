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
    bool fromBeginning = false,
  }) async {
    await _bookInterface.updateBook(
      bookId: bookId,
      userId: userId,
      status: BookStatus.inProgress,
      readPagesAmount: fromBeginning ? 0 : null,
    );
  }
}
