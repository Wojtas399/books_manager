import 'package:app/domain/use_cases/auth/send_reset_password_email_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSendResetPasswordEmailUseCase extends Mock
    implements SendResetPasswordEmailUseCase {
  void mock({Object? throwable}) {
    if (throwable != null) {
      when(_call).thenThrow(throwable);
    } else {
      when(_call).thenAnswer((_) async => '');
    }
  }

  Future<void> _call() {
    return execute(
      email: any(named: 'email'),
    );
  }
}
