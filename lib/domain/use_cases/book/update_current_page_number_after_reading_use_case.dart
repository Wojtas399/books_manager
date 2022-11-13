import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/day/add_new_read_book_to_user_days_use_case.dart';
import 'package:app/models/error.dart';

class UpdateCurrentPageNumberAfterReadingUseCase {
  late final BookInterface _bookInterface;
  late final AddNewReadBookToUserDaysUseCase _addNewReadBookToUserDaysUseCase;

  UpdateCurrentPageNumberAfterReadingUseCase({
    required BookInterface bookInterface,
    required AddNewReadBookToUserDaysUseCase addNewReadBookToUserDaysUseCase,
  }) {
    _bookInterface = bookInterface;
    _addNewReadBookToUserDaysUseCase = addNewReadBookToUserDaysUseCase;
  }

  Future<void> execute({
    required String bookId,
    required String userId,
    required int newCurrentPageNumber,
  }) async {
    final Book book = await _loadBook(bookId, userId);
    final int readPagesAmount = await _countReadPagesAmount(
      bookId,
      userId,
      book.allPagesAmount,
      book.readPagesAmount,
      newCurrentPageNumber,
    );
    BookStatus? newBookStatus;
    if (newCurrentPageNumber == book.allPagesAmount) {
      newBookStatus = BookStatus.finished;
    }
    final ReadBook readBook = ReadBook(
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    await _bookInterface.updateBook(
      bookId: bookId,
      userId: userId,
      readPagesAmount: newCurrentPageNumber,
      status: newBookStatus,
    );
    await _addNewReadBookToUserDaysUseCase.execute(
      userId: userId,
      readBook: readBook,
    );
  }

  Future<int> _countReadPagesAmount(
    String bookId,
    String userId,
    int bookAllPagesAmount,
    int bookReadPagesAmount,
    int newCurrentPageNumber,
  ) async {
    if (newCurrentPageNumber > bookAllPagesAmount) {
      throw const BookError(
        code: BookErrorCode.newCurrentPageIsTooHigh,
      );
    } else if (newCurrentPageNumber <= bookReadPagesAmount) {
      throw const BookError(
        code: BookErrorCode.newCurrentPageIsLowerThanReadPagesAmount,
      );
    }
    return newCurrentPageNumber - bookReadPagesAmount;
  }

  Future<Book> _loadBook(String bookId, String userId) async {
    final Book? book =
        await _bookInterface.getBook(bookId: bookId, userId: userId).first;
    if (book == null) {
      throw '(UpdateCurrentPageNumberAfterReadingUseCase) Cannot load book';
    }
    return book;
  }
}
