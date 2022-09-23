import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/interfaces/mock_book_interface.dart';
import '../../mocks/interfaces/mock_user_interface.dart';

void main() {
  final userInterface = MockUserInterface();
  final bookInterface = MockBookInterface();
  final useCase = InitializeUserDataUseCase(
    userInterface: userInterface,
    bookInterface: bookInterface,
  );

  test(
    'should call methods responsible for refreshing user and his books and should call method responsible for loading user data',
    () async {
      const String userId = 'u1';
      userInterface.mockRefreshUser();
      bookInterface.mockRefreshUserBooks();
      userInterface.mockLoadUser();

      await useCase.execute(userId: userId);

      verify(
        () => userInterface.refreshUser(userId: userId),
      ).called(1);
      verify(
        () => bookInterface.refreshUserBooks(userId: userId),
      ).called(1);
      verify(
        () => userInterface.loadUser(userId: userId),
      ).called(1);
    },
  );
}
