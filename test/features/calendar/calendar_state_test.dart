import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalendarState state;

  setUp(() {
    state = CalendarState(
      status: const BlocStatusInitial(),
      todayDate: DateTime(2022, 9, 20),
      daysOfReading: const [],
    );
  });

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with today date',
    () {
      final DateTime expectedTodayDate = DateTime(2022, 9, 20);

      state = state.copyWith(todayDate: expectedTodayDate);
      final state2 = state.copyWith();

      expect(state.todayDate, expectedTodayDate);
      expect(state2.todayDate, expectedTodayDate);
    },
  );

  test(
    'copy with days of reading',
    () {
      final List<Day> expectedDaysOfReading = [
        createDay(
          userId: 'u1',
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 20),
          ],
        ),
        createDay(
          userId: 'u1',
          date: DateTime(2022, 9, 18),
          readBooks: [
            createReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
      ];

      state = state.copyWith(daysOfReading: expectedDaysOfReading);
      final state2 = state.copyWith();

      expect(state.daysOfReading, expectedDaysOfReading);
      expect(state2.daysOfReading, expectedDaysOfReading);
    },
  );

  test(
    'dates of user days of reading, should return dates of days of reading',
    () {
      final List<Day> userDays = [
        createDay(
          date: DateTime(2022, 10, 5),
        ),
        createDay(
          date: DateTime(2022, 10, 3),
        ),
        createDay(
          date: DateTime(2022, 10, 1),
        ),
      ];
      final List<DateTime> expectedDates = [
        DateTime(2022, 10, 5),
        DateTime(2022, 10, 3),
        DateTime(2022, 10, 1),
      ];
      state = state.copyWith(daysOfReading: userDays);

      final List<DateTime>? dates = state.datesOfDaysOfReading;

      expect(dates, expectedDates);
    },
  );

  test(
    'get read books from day, should return read books from given date',
    () {
      final DateTime date = DateTime(2022, 10, 2);
      final List<Day> userDays = [
        createDay(
          date: DateTime(2022, 10, 5),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 20),
            createReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
        createDay(
          date: DateTime(2022, 10, 2),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 200),
          ],
        ),
      ];
      final List<ReadBook> expectedReadBooks = userDays.last.readBooks;
      state = state.copyWith(daysOfReading: userDays);

      final List<ReadBook> readBooks = state.getReadBooksFromDay(date);

      expect(readBooks, expectedReadBooks);
    },
  );

  test(
    'get read books from day, should return empty list if user did not read any books in given date',
    () {
      final DateTime date = DateTime(2022, 10, 2);

      final List<ReadBook> readBooks = state.getReadBooksFromDay(date);

      expect(readBooks, []);
    },
  );
}
