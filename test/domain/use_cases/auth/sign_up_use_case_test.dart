import 'package:app/domain/entities/user.dart';
import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_auth_interface.dart';
import '../../../mocks/domain/interfaces/mock_user_interface.dart';

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
      authInterface.mockSignUp(signedUpUserId: signedUpUserId);
      userInterface.mockAddUser();

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
