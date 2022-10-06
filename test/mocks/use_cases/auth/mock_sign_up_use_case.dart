import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {
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
      password: any(named: 'password'),
    );
  }
}
