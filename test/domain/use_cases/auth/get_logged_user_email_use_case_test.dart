import 'package:app/domain/use_cases/auth/get_logged_user_email_use_case.dart';
import 'package:test/test.dart';

import '../../../mocks/domain/interfaces/mock_auth_interface.dart';

void main() {
  final authInterface = MockAuthInterface();
  final useCase = GetLoggedUserEmailUseCase(authInterface: authInterface);

  test(
    'should return stream with logged user email',
    () async {
      const String expectedLoggedUserEmail = 'email@example.com';
      authInterface.mockGetLoggedUserEmail(
        loggedUserEmail: expectedLoggedUserEmail,
      );

      final Stream<String?> loggedUserEmail$ = useCase.execute();

      expect(await loggedUserEmail$.first, expectedLoggedUserEmail);
    },
  );
}
