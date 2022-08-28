import 'package:app/domain/use_cases/auth/load_logged_user_id_use_case.dart';
import 'package:app/interfaces/auth_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = LoadLoggedUserIdUseCase(authInterface: authInterface);

  test(
    'should call method responsible for loading logged user id',
    () async {
      when(
        () => authInterface.loadLoggedUserId(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => authInterface.loadLoggedUserId(),
      ).called(1);
    },
  );
}
