import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/day/get_user_days_from_month_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  final useCase = GetUserDaysFromMonthUseCase(dayInterface: dayInterface);

  test(
    'should return stream which contains days belonging to user and given month with year',
    () async {
      const String userId = 'u1';
      final List<Day> allUserDays = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 14),
          readBooks: [
            createReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
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
        createDay(
          userId: userId,
          date: DateTime(2022, 7, 10),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 100),
          ],
        ),
      ];
      final List<Day> expectedDays = [allUserDays[1], allUserDays[2]];
      dayInterface.mockGetUserDays(userDays: allUserDays);

      final Stream<List<Day>> daysFromMonth$ = useCase.execute(
        userId: userId,
        month: 8,
        year: 2022,
      );

      expect(await daysFromMonth$.first, expectedDays);
    },
  );
}
