import 'package:app/domain/use_cases/user/load_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadUserUseCase extends Mock implements LoadUserUseCase {
  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
