import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/models/error.dart';
import 'package:app/providers/date_provider.dart';

class UpdateCurrentPageNumberAfterReadingUseCase {
  late final BookInterface _bookInterface;
  late final DayInterface _dayInterface;
  late final DateProvider _dateProvider;

  UpdateCurrentPageNumberAfterReadingUseCase({
    required BookInterface bookInterface,
    required DayInterface dayInterface,
    required DateProvider dateProvider,
  }) {
    _bookInterface = bookInterface;
    _dayInterface = dayInterface;
    _dateProvider = dateProvider;
  }

  Future<void> execute({
    required String bookId,
    required int newCurrentPageNumber,
  }) async {
    final Book book = await _bookInterface.getBookById(bookId: bookId).first;
    final int allPagesAmount = book.allPagesAmount;
    if (newCurrentPageNumber > allPagesAmount) {
      throw const BookError(code: BookErrorCode.newCurrentPageIsTooHigh);
    } else if (newCurrentPageNumber < book.readPagesAmount) {
      throw const BookError(code: BookErrorCode.newCurrentPageIsLower);
    }
    await _bookInterface.updateBookData(
      bookId: bookId,
      readPagesAmount: newCurrentPageNumber,
      bookStatus:
          newCurrentPageNumber == allPagesAmount ? BookStatus.finished : null,
    );
    final int readPagesAmount = newCurrentPageNumber - book.readPagesAmount;
    final DateTime todayDate = _dateProvider.getNow();
    await _dayInterface.addNewReadPages(
      userId: book.userId,
      date: todayDate,
      bookId: bookId,
      amountOfReadPagesToAdd: readPagesAmount,
    );
  }
}
