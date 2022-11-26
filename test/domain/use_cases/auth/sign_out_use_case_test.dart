import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_auth_interface.dart';
import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final bookInterface = MockBookInterface();
  final useCase = SignOutUseCase(
    authInterface: authInterface,
    bookInterface: bookInterface,
  );

  test(
    'should call method responsible for signing out user',
    () async {
      authInterface.mockSignOut();

      await useCase.execute();

      verify(
        () => bookInterface.dispose(),
      ).called(1);
      verify(
        () => authInterface.signOut(),
      ).called(1);
    },
  );
}
