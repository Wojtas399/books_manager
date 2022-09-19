import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserInterface extends Mock implements UserInterface {}

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final userInterface = MockUserInterface();
  final bookInterface = MockBookInterface();
  final useCase = InitializeUserDataUseCase(
    userInterface: userInterface,
    bookInterface: bookInterface,
  );

  test(
    'should call methods responsible for refreshing user and his books',
    () async {
      const String userId = 'u1';
      when(
        () => userInterface.refreshUser(userId: userId),
      ).thenAnswer((_) async => '');
      when(
        () => bookInterface.refreshUserBooks(userId: userId),
      ).thenAnswer((_) async => '');

      await useCase.execute(userId: userId);

      verify(
        () => userInterface.refreshUser(userId: userId),
      ).called(1);
      verify(
        () => bookInterface.refreshUserBooks(userId: userId),
      ).called(1);
    },
  );
}
