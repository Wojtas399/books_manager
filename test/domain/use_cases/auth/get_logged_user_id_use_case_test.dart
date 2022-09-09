import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = GetLoggedUserIdUseCase(authInterface: authInterface);

  test(
    'should return stream which contains logged user id',
    () async {
      const String loggedUserId = 'userId';
      when(
        () => authInterface.loggedUserId$,
      ).thenAnswer((_) => Stream.value(loggedUserId));

      final Stream<String?> loggedUserId$ = useCase.execute();

      expect(await loggedUserId$.first, loggedUserId);
    },
  );
}
