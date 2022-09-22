import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final userInterface = MockUserInterface();
  final useCase = SignUpUseCase(
    authInterface: authInterface,
    userInterface: userInterface,
  );

  test(
    'should call method from auth interface responsible for signing up user and should call method from user interface responsible for adding user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const String signedUpUserId = 'u1';
      final User user = createUser(
        id: signedUpUserId,
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
      );
      when(
        () => authInterface.signUp(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => signedUpUserId);
      when(
        () => userInterface.addUser(user: user),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        email: email,
        password: password,
      );

      verify(
        () => authInterface.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
      verify(
        () => userInterface.addUser(user: user),
      ).called(1);
    },
  );
}
