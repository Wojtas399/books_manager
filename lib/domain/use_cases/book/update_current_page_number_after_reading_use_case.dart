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
    // final int readPagesAmount =
    //     await _countReadPagesAmount(bookId, newCurrentPageNumber);
    // final ReadBook readBook = ReadBook(
    //   bookId: bookId,
    //   readPagesAmount: readPagesAmount,
    // );
    // await _bookInterface.updateBookData(
    //   bookId: bookId,
    //   readPagesAmount: newCurrentPageNumber,
    // );
    // await _addNewReadBookToUserDaysUseCase.execute(
    //   userId: userId,
    //   readBook: readBook,
    // );
  }

  // Future<int> _countReadPagesAmount(
  //   String bookId,
  //   int newCurrentPageNumber,
  // ) async {
  //   final Book book = await _loadBook(bookId);
  //   if (newCurrentPageNumber > book.allPagesAmount) {
  //     throw const BookError(
  //       code: BookErrorCode.newCurrentPageIsTooHigh,
  //     );
  //   } else if (newCurrentPageNumber <= book.readPagesAmount) {
  //     throw const BookError(
  //       code: BookErrorCode.newCurrentPageIsLowerThanReadPagesAmount,
  //     );
  //   }
  //   return newCurrentPageNumber - book.readPagesAmount;
  // }
  //
  // Future<Book> _loadBook(String bookId) async {
  //   final Book? book = await _bookInterface.getBookById(bookId: bookId).first;
  //   if (book == null) {
  //     throw '(UpdateCurrentPageNumberAfterReadingUseCase) Cannot load book';
  //   }
  //   return book;
  // }
}
