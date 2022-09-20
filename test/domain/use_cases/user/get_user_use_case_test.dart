import 'package:app/domain/entities/user.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/interfaces/mock_user_interface.dart';

void main() {
  final userInterface = MockUserInterface();
  final useCase = GetUserUseCase(userInterface: userInterface);
  final User user = createUser(id: 'u1');

  test(
    'should return stream which contains user matching to given id',
    () async {
      userInterface.mockGetUser(user: user);

      final Stream<User> user$ = useCase.execute(userId: user.id);

      expect(await user$.first, user);
    },
  );
}
