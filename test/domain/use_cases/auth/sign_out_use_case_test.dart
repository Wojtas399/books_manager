import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_auth_interface.dart';
import '../../../mocks/domain/interfaces/mock_user_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final userInterface = MockUserInterface();
  final useCase = SignOutUseCase(
    authInterface: authInterface,
    userInterface: userInterface,
  );

  test(
    'should reset user repo and should call method responsible for signing out user',
    () async {
      authInterface.mockSignOut();

      await useCase.execute();

      verify(
        () => userInterface.reset(),
      ).called(1);
      verify(
        () => authInterface.signOut(),
      ).called(1);
    },
  );
}
