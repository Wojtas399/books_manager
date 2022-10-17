import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSignOutUseCase extends Mock implements SignOutUseCase {
  void mock() {
    when(
      () => execute(),
    ).thenAnswer((_) async => '');
  }
}
