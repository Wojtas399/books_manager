import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/error.dart';

class UpdateCurrentPageNumberInBookUseCase {
  late final BookInterface _bookInterface;

  UpdateCurrentPageNumberInBookUseCase({
    required BookInterface bookInterface,
  }) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String bookId,
    required int newCurrentPageNumber,
  }) async {
    final Book book = await _bookInterface.getBookById(bookId: bookId).first;
    final int allPagesAmount = book.allPagesAmount;
    if (newCurrentPageNumber > allPagesAmount) {
      throw const BookError(code: BookErrorCode.newCurrentPageIsTooHigh);
    }
    await _bookInterface.updateBookData(
      bookId: bookId,
      readPagesAmount: newCurrentPageNumber,
      bookStatus:
          newCurrentPageNumber == allPagesAmount ? BookStatus.finished : null,
    );
  }
}
