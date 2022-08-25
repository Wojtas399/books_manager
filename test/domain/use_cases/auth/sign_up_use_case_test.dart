import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:app/interfaces/auth_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SignUpUseCase(
    authInterface: authInterface,
  );

  test(
    'should call method responsible for signing up user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => authInterface.signUp(
          email: email,
          password: password,
        ),
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
    },
  );
}
