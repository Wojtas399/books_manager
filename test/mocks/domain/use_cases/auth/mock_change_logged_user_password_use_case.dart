import 'package:app/domain/use_cases/auth/change_logged_user_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockChangeLoggedUserPasswordUseCase extends Mock
    implements ChangeLoggedUserPasswordUseCase {
  void mock({Object? throwable}) {
    if (throwable != null) {
      when(_execute).thenThrow(throwable);
    } else {
      when(_execute).thenAnswer((_) async => '');
    }
  }

  Future<void> _execute() {
    return execute(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
    );
  }
}
