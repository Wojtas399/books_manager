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
    final int readPagesAmount =
        await _countReadPagesAmount(bookId, userId, newCurrentPageNumber);
    final ReadBook readBook = ReadBook(
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    await _bookInterface.updateBook(
      bookId: bookId,
      userId: userId,
      readPagesAmount: newCurrentPageNumber,
    );
    await _addNewReadBookToUserDaysUseCase.execute(
      userId: userId,
      readBook: readBook,
    );
  }

  Future<int> _countReadPagesAmount(
    String bookId,
    String userId,
    int newCurrentPageNumber,
  ) async {
    final Book book = await _loadBook(bookId, userId);
    if (newCurrentPageNumber > book.allPagesAmount) {
      throw const BookError(
        code: BookErrorCode.newCurrentPageIsTooHigh,
      );
    } else if (newCurrentPageNumber <= book.readPagesAmount) {
      throw const BookError(
        code: BookErrorCode.newCurrentPageIsLowerThanReadPagesAmount,
      );
    }
    return newCurrentPageNumber - book.readPagesAmount;
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
