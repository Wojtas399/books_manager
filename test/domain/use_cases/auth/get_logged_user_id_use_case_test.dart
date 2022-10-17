import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/domain/interfaces/mock_auth_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final useCase = GetLoggedUserIdUseCase(authInterface: authInterface);

  test(
    'should return stream which contains logged user id',
    () async {
      const String loggedUserId = 'userId';
      authInterface.mockGetLoggedUserId(loggedUserId: loggedUserId);

      final Stream<String?> loggedUserId$ = useCase.execute();

      expect(await loggedUserId$.first, loggedUserId);
    },
  );
}
