import 'package:app/domain/entities/day.dart';
import 'package:app/extensions/list_of_read_books_extensions.dart';

extension ListOfDaysExtensions on List<Day> {
  bool doesNotContainDate(DateTime date) {
    final List<DateTime> dates = map((Day day) => day.date).toList();
    return !dates.contains(date);
  }

  List<Day> selectDaysContainingBook(String bookId) {
    return where((Day day) => day.readBooks.containsBook(bookId)).toList();
  }

  Day selectDayByDate(DateTime date) {
    return firstWhere((Day day) => day.date == date);
  }
}
