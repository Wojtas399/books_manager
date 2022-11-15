import 'package:app/domain/use_cases/auth/get_logged_user_email_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLoggedUserEmailUseCase extends Mock
    implements GetLoggedUserEmailUseCase {
  void mock({String? loggedUserEmail}) {
    when(
      () => execute(),
    ).thenAnswer((_) => Stream.value(loggedUserEmail));
  }
}
