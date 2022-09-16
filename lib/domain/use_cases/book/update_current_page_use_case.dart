import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/error.dart';

class UpdateCurrentPageUseCase {
  late final BookInterface _bookInterface;

  UpdateCurrentPageUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String bookId,
    required int newCurrentPage,
  }) async {
    final Book book = await _bookInterface.getBookById(bookId: bookId).first;
    final int allPagesAmount = book.allPagesAmount;
    if (newCurrentPage > allPagesAmount) {
      throw BookError(bookErrorCode: BookErrorCode.newCurrentPageIsTooHigh);
    }
    await _bookInterface.updateBookData(
      bookId: bookId,
      readPagesAmount: newCurrentPage,
      bookStatus: newCurrentPage == allPagesAmount ? BookStatus.finished : null,
    );
  }
}
