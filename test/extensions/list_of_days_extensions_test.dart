import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/extensions/list_of_days_extension.dart';
import 'package:test/test.dart';

void main() {
  final List<Day> days = [
    createDay(
      date: DateTime(2022, 10, 15),
      userId: 'u1',
      readBooks: [
        createReadBook(bookId: 'b1', readPagesAmount: 100),
        createReadBook(bookId: 'b2', readPagesAmount: 150),
      ],
    ),
    createDay(
      date: DateTime(2022, 10, 16),
      userId: 'u1',
      readBooks: [
        createReadBook(bookId: 'b1', readPagesAmount: 200),
      ],
    ),
    createDay(
      date: DateTime(2022, 10, 18),
      userId: 'u1',
      readBooks: [
        createReadBook(bookId: 'b2', readPagesAmount: 100),
      ],
    ),
  ];

  test(
    'does not contain date, should return true if no one day matches to given date',
    () {
      final DateTime date = DateTime(2022, 10, 14);

      final bool result = days.doesNotContainDate(date);

      expect(result, true);
    },
  );

  test(
    'does not contain date, should return false if day with given date exists in list',
    () {
      final DateTime date = days.last.date;

      final bool result = days.doesNotContainDate(date);

      expect(result, false);
    },
  );

  test(
    'select days containing book, should return days which contain read book with given book id',
    () {
      const String bookId = 'b2';
      final List<Day> expectedDays = [days.first, days.last];

      final List<Day> daysContainingBook =
          days.selectDaysContainingBook(bookId);

      expect(daysContainingBook, expectedDays);
    },
  );

  test(
    'select day by date, should return day from given date',
    () {
      final Day expectedDay = days.first;

      final Day day = days.selectDayByDate(days.first.date);

      expect(day, expectedDay);
    },
  );
}
