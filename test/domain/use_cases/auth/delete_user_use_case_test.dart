import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/domain/use_cases/auth/delete_user_use_case.dart';
import 'package:app/interfaces/auth_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = DeleteUserUseCase(authInterface: authInterface);

  test(
    'should call method responsible for deleting logged user',
    () async {
      const String password = 'password123';
      when(
        () => authInterface.deleteLoggedUser(password: password),
      ).thenAnswer((_) async => '');

      await useCase.execute(password: password);

      verify(
        () => authInterface.deleteLoggedUser(password: password),
      ).called(1);
    },
  );
}
