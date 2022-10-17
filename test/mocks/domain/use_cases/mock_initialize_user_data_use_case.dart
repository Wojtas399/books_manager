import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockInitializeUserDataUseCase extends Mock
    implements InitializeUserDataUseCase {
  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
