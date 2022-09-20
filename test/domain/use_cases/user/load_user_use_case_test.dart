import 'package:app/domain/use_cases/user/load_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_user_interface.dart';

void main() {
  final userInterface = MockUserInterface();
  final useCase = LoadUserUseCase(userInterface: userInterface);

  test(
    'should call method responsible for loading user',
    () async {
      const String userId = 'u1';
      userInterface.mockLoadUser();

      await useCase.execute(userId: userId);

      verify(
        () => userInterface.loadUser(userId: userId),
      ).called(1);
    },
  );
}
