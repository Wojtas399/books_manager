import 'package:app/domain/use_cases/auth/change_logged_user_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_auth_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final useCase = ChangeLoggedUserPasswordUseCase(
    authInterface: authInterface,
  );

  test(
    'should call method responsible for changing logged user password',
    () async {
      const String currentPassword = 'currentPassword';
      const String newPassword = 'newPassword';
      authInterface.mockChangeLoggedUserPassword();

      useCase.execute(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      verify(
        () => authInterface.changeLoggedUserPassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ).called(1);
    },
  );
}
