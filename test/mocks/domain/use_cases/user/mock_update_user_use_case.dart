import 'package:app/domain/use_cases/user/update_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {
  void mock({Object? throwable}) {
    if (throwable != null) {
      when(_execute).thenThrow(throwable);
    } else {
      when(_execute).thenAnswer((_) async => '');
    }
  }

  Future<void> _execute() {
    return execute(
      userId: any(named: 'userId'),
      isDarkModeOn: any(named: 'isDarkModeOn'),
      isDarkModeCompatibilityWithSystemOn: any(
        named: 'isDarkModeCompatibilityWithSystemOn',
      ),
    );
  }
}
