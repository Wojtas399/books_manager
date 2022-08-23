import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/domain/entities/auth_state.dart';
import 'package:app/domain/use_cases/auth/get_auth_state_use_case.dart';
import 'package:app/interfaces/auth_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = GetAuthStateUseCase(authInterface: authInterface);

  test(
    'should return stream which contains auth state',
    () async {
      const AuthState expectedState = AuthState.signedIn;
      when(
        () => authInterface.authState$,
      ).thenAnswer((_) => Stream.value(expectedState));

      final Stream<AuthState> authState$ = useCase.execute();

      expect(await authState$.first, expectedState);
    },
  );
}
