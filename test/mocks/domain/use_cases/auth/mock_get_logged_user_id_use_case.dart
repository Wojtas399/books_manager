import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLoggedUserIdUseCase extends Mock
    implements GetLoggedUserIdUseCase {
  void mock({String? loggedUserId}) {
    when(
      () => execute(),
    ).thenAnswer((_) => Stream.value(loggedUserId));
  }
}
