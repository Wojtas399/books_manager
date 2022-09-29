import 'package:app/domain/use_cases/day/load_user_days_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  final useCase = LoadUserDaysUseCase(dayInterface: dayInterface);

  test(
    "should call method responsible for loading user's days",
    () async {
      const String userId = 'u1';
      dayInterface.mockLoadUserDays();

      await useCase.execute(userId: userId);

      verify(
        () => dayInterface.loadUserDays(userId: userId),
      ).called(1);
    },
  );
}
