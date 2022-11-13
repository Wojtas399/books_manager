import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/extensions/list_of_days_extension.dart';

class DeleteBookFromUserDaysUseCase {
  late final DayInterface _dayInterface;

  DeleteBookFromUserDaysUseCase({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
  }

  Future<void> execute({
    required String userId,
    required String bookId,
  }) async {
    final List<Day> userDaysContainingBook =
        await _loadUserDaysContainingBook(userId, bookId);
    for (final Day day in userDaysContainingBook) {
      if (day.readBooks.length == 1) {
        await _dayInterface.deleteDay(userId: userId, date: day.date);
      } else {
        final Day updatedDay = _deleteBookFromDayReadBooksList(day, bookId);
        await _dayInterface.updateDay(updatedDay: updatedDay);
      }
    }
  }

  Future<List<Day>> _loadUserDaysContainingBook(
    String userId,
    String bookId,
  ) async {
    final List<Day> userDays =
        await _dayInterface.getUserDays(userId: userId).first;
    return userDays.selectDaysContainingBook(bookId);
  }

  Day _deleteBookFromDayReadBooksList(Day day, String bookId) {
    final List<ReadBook> updatedReadBooks = [...day.readBooks];
    updatedReadBooks.removeWhere(
      (ReadBook readBook) => readBook.bookId == bookId,
    );
    return day.copyWith(
      readBooks: updatedReadBooks,
    );
  }
}
