import 'package:app/domain/entities/user.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {
  void mock({required User user}) {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(user));
  }
}
