import 'package:app/domain/entities/book.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/day/add_new_read_book_to_user_days_use_case.dart';

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
    required String userId,
    required String bookId,
    required int newCurrentPageNumber,
  }) async {
    final int readPagesAmount =
        await _countReadPagesAmount(bookId, newCurrentPageNumber);
    final ReadBook readBook = ReadBook(
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    await _bookInterface.updateBookData(
      bookId: bookId,
      readPagesAmount: newCurrentPageNumber,
    );
    await _addNewReadBookToUserDaysUseCase.execute(
      userId: userId,
      readBook: readBook,
    );
  }

  Future<int> _countReadPagesAmount(
    String bookId,
    int newCurrentPageNumber,
  ) async {
    final int currentPageNumber = await _loadBookCurrentPageNumber(bookId);
    return newCurrentPageNumber - currentPageNumber;
  }

  Future<int> _loadBookCurrentPageNumber(String bookId) async {
    final Book? book = await _bookInterface.getBookById(bookId: bookId).first;
    return book?.readPagesAmount ?? 0;
  }
}
