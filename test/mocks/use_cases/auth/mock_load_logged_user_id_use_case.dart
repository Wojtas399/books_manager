import 'package:app/domain/use_cases/auth/load_logged_user_id_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadLoggedUserIdUseCase extends Mock
    implements LoadLoggedUserIdUseCase {
  void mock() {
    when(
      () => execute(),
    ).thenAnswer((_) async => '');
  }
}
