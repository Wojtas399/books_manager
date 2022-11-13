import 'package:app/domain/entities/day.dart';
import 'package:app/extensions/list_of_read_books_extensions.dart';
import 'package:app/utils/date_utils.dart';

extension ListOfDaysExtensions on List<Day> {
  bool doesNotContainDate(DateTime date) {
    final List<DateTime> dates = map((Day day) => day.date).toList();
    for (int i = 0; i < dates.length; i++) {
      if (DateUtils.areDatesTheSame(date1: dates[i], date2: date)) {
        return false;
      }
    }
    return true;
  }

  List<Day> selectDaysContainingBook(String bookId) {
    return where((Day day) => day.readBooks.containsBook(bookId)).toList();
  }

  Day selectDayByDate(DateTime date) {
    return firstWhere(
      (Day day) => DateUtils.areDatesTheSame(
        date1: day.date,
        date2: date,
      ),
    );
  }
}
