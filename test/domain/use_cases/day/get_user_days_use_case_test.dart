import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/day/get_user_days_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  final useCase = GetUserDaysUseCase(dayInterface: dayInterface);

  test(
    'should return stream which contains days belonging to user',
    () async {
      const String userId = 'u1';
      final List<Day> expectedUserDays = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 20),
            createReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 15),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 50),
          ],
        ),
      ];
      dayInterface.mockGetUserDays(userDays: expectedUserDays);

      final Stream<List<Day>> userDays$ = useCase.execute(userId: userId);

      expect(await userDays$.first, expectedUserDays);
    },
  );
}
