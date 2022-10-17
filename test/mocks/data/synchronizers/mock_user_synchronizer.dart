import 'package:app/data/synchronizers/user_synchronizer.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSynchronizer extends Mock implements UserSynchronizer {
  void mockSynchronizeUser() {
    when(
      () => synchronizeUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
