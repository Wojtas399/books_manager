import 'package:app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_auth_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SignInUseCase(authInterface: authInterface);

  test(
    'should call method responsible for signing in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      authInterface.mockSignIn(signedInUserId: '');

      await useCase.execute(email: email, password: password);

      verify(
        () => authInterface.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );
}
