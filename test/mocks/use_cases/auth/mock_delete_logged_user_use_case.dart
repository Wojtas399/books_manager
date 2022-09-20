import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteLoggedUserUseCase extends Mock
    implements DeleteLoggedUserUseCase {
  void mock({Object? throwable}) {
    if (throwable != null) {
      when(_executeCall).thenThrow(throwable);
    } else {
      when(_executeCall).thenAnswer((_) async => '');
    }
  }

  Future<void> _executeCall() {
    return execute(
      password: any(named: 'password'),
    );
  }
}
