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
      displayingMonth: 9,
      displayingYear: 2022,
      userDaysFromMonth: const [],
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
    'copy with displaying month',
    () {
      const int expectedDisplayingMonth = 8;

      state = state.copyWith(displayingMonth: expectedDisplayingMonth);
      final state2 = state.copyWith();

      expect(state.displayingMonth, expectedDisplayingMonth);
      expect(state2.displayingMonth, expectedDisplayingMonth);
    },
  );

  test(
    'copy with displaying year',
    () {
      const int expectedDisplayingYear = 2021;

      state = state.copyWith(displayingYear: expectedDisplayingYear);
      final state2 = state.copyWith();

      expect(state.displayingYear, expectedDisplayingYear);
      expect(state2.displayingYear, expectedDisplayingYear);
    },
  );

  test(
    'copy with user days from month',
    () {
      final List<Day> expectedUserDaysFromMonth = [
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

      state = state.copyWith(userDaysFromMonth: expectedUserDaysFromMonth);
      final state2 = state.copyWith();

      expect(state.userDaysFromMonth, expectedUserDaysFromMonth);
      expect(state2.userDaysFromMonth, expectedUserDaysFromMonth);
    },
  );

  test(
    'copy with loading status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWithLoadingStatus();

      expect(state.status, expectedStatus);
    },
  );

  test(
    'copy with logged user not found status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoggedUserNotFound();

      state = state.copyWithLoggedUserNotFoundStatus();

      expect(state.status, expectedStatus);
    },
  );
}
