import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/providers/date_provider.dart';

class AddNewReadBookToUserDaysUseCase {
  late final DayInterface _dayInterface;
  late final DateProvider _dateProvider;

  AddNewReadBookToUserDaysUseCase({
    required DayInterface dayInterface,
    required DateProvider dateProvider,
  }) {
    _dayInterface = dayInterface;
    _dateProvider = dateProvider;
  }

  Future<void> execute({
    required String userId,
    required ReadBook readBook,
  }) async {
    final DateTime todayDate = _dateProvider.getNow();
    final List<Day> userDays = await _loadUserDays(userId);
    if (userDays.doesNotContainDate(todayDate)) {
      await _addNewDayToUserDays(userId, todayDate, readBook);
    } else {
      final Day day = userDays.selectDayByDate(todayDate);
      await _updateDayInUserDays(day, readBook);
    }
  }

  Future<List<Day>> _loadUserDays(String userId) async {
    return await _dayInterface.getUserDays(userId: userId).first ?? [];
  }

  Future<void> _addNewDayToUserDays(
    String userId,
    DateTime date,
    ReadBook readBook,
  ) async {
    final Day dayToAdd = Day(
      userId: userId,
      date: date,
      readBooks: [readBook],
    );
    await _dayInterface.addNewDay(day: dayToAdd);
  }

  Future<void> _updateDayInUserDays(Day day, ReadBook readBook) async {
    final Day updatedDay = _updateReadBooksInDay(day, readBook);
    await _dayInterface.updateDay(updatedDay: updatedDay);
  }

  Day _updateReadBooksInDay(Day day, ReadBook readBook) {
    final List<ReadBook> updatedReadBooks = [...day.readBooks];
    if (updatedReadBooks.doesNotContainBook(readBook.bookId)) {
      updatedReadBooks.add(readBook);
    } else {
      final int readBookIndex =
          updatedReadBooks.selectReadBookIndexByBookId(readBook.bookId);
      updatedReadBooks[readBookIndex] = readBook;
    }
    return day.copyWith(
      readBooks: updatedReadBooks,
    );
  }
}

extension DaysExtensions on List<Day> {
  bool doesNotContainDate(DateTime date) {
    final List<DateTime> dates = map((Day day) => day.date).toList();
    return !dates.contains(date);
  }

  Day selectDayByDate(DateTime date) {
    return firstWhere((Day day) => day.date == date);
  }
}

extension ReadBooksExtensions on List<ReadBook> {
  bool doesNotContainBook(String bookId) {
    final List<String> booksIds =
        map((ReadBook readBook) => readBook.bookId).toList();
    return !booksIds.contains(bookId);
  }

  int selectReadBookIndexByBookId(String bookId) {
    return indexWhere((ReadBook readBook) => readBook.bookId == bookId);
  }
}
