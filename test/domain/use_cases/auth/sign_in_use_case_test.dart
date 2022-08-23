import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:app/interfaces/auth_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SignInUseCase(authInterface: authInterface);

  test(
    'should call method responsible for signing in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => authInterface.signIn(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => '');

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
