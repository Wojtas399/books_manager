import 'package:app/domain/use_cases/auth/send_reset_password_email_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_auth_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SendResetPasswordEmailUseCase(authInterface: authInterface);

  test(
    'should call method responsible for sending password reset email',
    () async {
      const String email = 'email@example.com';
      authInterface.mockSendPasswordResetEmail();

      await useCase.execute(email: email);

      verify(
        () => authInterface.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );
}
