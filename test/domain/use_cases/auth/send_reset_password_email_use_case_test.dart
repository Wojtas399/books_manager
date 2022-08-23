import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/domain/use_cases/auth/send_reset_password_email_use_case.dart';
import 'package:app/interfaces/auth_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SendResetPasswordEmailUseCase(authInterface: authInterface);

  test(
    'should call method responsible for sending password reset email',
    () async {
      const String email = 'email@example.com';
      when(
        () => authInterface.sendPasswordResetEmail(email: email),
      ).thenAnswer((_) async => '');

      await useCase.execute(email: email);

      verify(
        () => authInterface.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );
}
