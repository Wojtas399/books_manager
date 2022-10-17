import 'package:app/domain/use_cases/auth/load_logged_user_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_auth_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final useCase = LoadLoggedUserIdUseCase(authInterface: authInterface);

  test(
    'should call method responsible for loading logged user id',
    () async {
      authInterface.mockLoadLoggedUserId();

      await useCase.execute();

      verify(
        () => authInterface.loadLoggedUserId(),
      ).called(1);
    },
  );
}
