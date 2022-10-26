import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/interfaces/mock_book_interface.dart';
import '../../mocks/domain/interfaces/mock_day_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final dayInterface = MockDayInterface();
  final useCase = InitializeUserDataUseCase(
    bookInterface: bookInterface,
    dayInterface: dayInterface,
  );

  test(
    'should call methods responsible for initializing user books and his days',
    () async {
      const String userId = 'u1';
      bookInterface.mockInitializeForUser();
      dayInterface.mockInitializeForUser();

      await useCase.execute(userId: userId);

      verify(
        () => bookInterface.initializeForUser(userId: userId),
      ).called(1);
      verify(
        () => dayInterface.initializeForUser(userId: userId),
      );
    },
  );
}
