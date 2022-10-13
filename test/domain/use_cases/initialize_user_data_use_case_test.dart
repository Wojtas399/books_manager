import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/interfaces/mock_book_interface.dart';
import '../../mocks/interfaces/mock_day_interface.dart';
import '../../mocks/interfaces/mock_user_interface.dart';

void main() {
  final userInterface = MockUserInterface();
  final bookInterface = MockBookInterface();
  final dayInterface = MockDayInterface();
  final useCase = InitializeUserDataUseCase(
    userInterface: userInterface,
    bookInterface: bookInterface,
    dayInterface: dayInterface,
  );

  test(
    'should call methods responsible for initializing user, his books and his days and should call method responsible for loading user data',
    () async {
      const String userId = 'u1';
      userInterface.mockInitializeUser();
      bookInterface.mockInitializeForUser();
      dayInterface.mockInitializeForUser();
      userInterface.mockLoadUser();

      await useCase.execute(userId: userId);

      verify(
        () => userInterface.initializeUser(userId: userId),
      ).called(1);
      verify(
        () => bookInterface.initializeForUser(userId: userId),
      ).called(1);
      verify(
        () => dayInterface.initializeForUser(userId: userId),
      );
      verify(
        () => userInterface.loadUser(userId: userId),
      ).called(1);
    },
  );
}
