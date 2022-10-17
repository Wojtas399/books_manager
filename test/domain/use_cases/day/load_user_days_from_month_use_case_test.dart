import 'package:app/domain/use_cases/day/load_user_days_from_month_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/domain/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  final useCase = LoadUserDaysFromMonthUseCase(dayInterface: dayInterface);

  test(
    'should call method responsible for loading user days from given month',
    () async {
      const String userId = 'u1';
      const int month = 9;
      const int year = 2022;
      dayInterface.mockLoadUserDaysFromMonth();

      useCase.execute(
        userId: userId,
        month: month,
        year: year,
      );

      verify(
        () => dayInterface.loadUserDaysFromMonth(
          userId: userId,
          month: month,
          year: year,
        ),
      ).called(1);
    },
  );
}
