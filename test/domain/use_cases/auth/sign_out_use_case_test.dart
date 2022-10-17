import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_auth_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SignOutUseCase(authInterface: authInterface);

  test(
    'should call method responsible for signing out user',
    () async {
      authInterface.mockSignOut();

      await useCase.execute();

      verify(
        () => authInterface.signOut(),
      ).called(1);
    },
  );
}
