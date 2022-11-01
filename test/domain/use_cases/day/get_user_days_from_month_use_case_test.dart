import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/day/get_user_days_from_month_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/domain/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  final useCase = GetUserDaysFromMonthUseCase(dayInterface: dayInterface);

  test(
    'should return the result of method responsible for getting user days from month',
    () async {
      const String userId = 'u1';
      final List<Day> expectedUserDaysFromMonth = [
        createDay(
          userId: userId,
          date: DateTime(2022, 8, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 20),
            createReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 8, 15),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 50),
          ],
        ),
      ];
      dayInterface.mockGetUserDaysFromMonth(
        userDaysFromMonth: expectedUserDaysFromMonth,
      );

      final Stream<List<Day>?> userDaysFromMonth$ = useCase.execute(
        userId: userId,
        month: 8,
        year: 2022,
      );

      expect(await userDaysFromMonth$.first, expectedUserDaysFromMonth);
    },
  );
}
