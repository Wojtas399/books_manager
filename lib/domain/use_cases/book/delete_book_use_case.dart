import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/day/delete_book_from_user_days_use_case.dart';

class DeleteBookUseCase {
  late final BookInterface _bookInterface;
  late final DeleteBookFromUserDaysUseCase _deleteBookFromUserDaysUseCase;

  DeleteBookUseCase({
    required BookInterface bookInterface,
    required DeleteBookFromUserDaysUseCase deleteBookFromUserDaysUseCase,
  }) {
    _bookInterface = bookInterface;
    _deleteBookFromUserDaysUseCase = deleteBookFromUserDaysUseCase;
  }

  Future<void> execute({
    required String bookId,
    required String userId,
  }) async {
    await _bookInterface.deleteBook(bookId: bookId, userId: userId);
    await _deleteBookFromUserDaysUseCase.execute(
      userId: userId,
      bookId: bookId,
    );
  }
}
