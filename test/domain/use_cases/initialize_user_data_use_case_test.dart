import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  final useCase = InitializeUserDataUseCase(
    dayInterface: dayInterface,
  );

  test(
    'should call method responsible for initializing user days',
    () async {
      const String userId = 'u1';
      dayInterface.mockInitializeForUser();

      await useCase.execute(userId: userId);

      verify(
        () => dayInterface.initializeForUser(userId: userId),
      );
    },
  );
}
