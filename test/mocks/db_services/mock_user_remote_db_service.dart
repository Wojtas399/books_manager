import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/models/db_user.dart';
import 'package:mocktail/mocktail.dart';

class FakeDbUser extends Fake implements DbUser {}

class MockUserRemoteDbService extends Mock implements UserRemoteDbService {
  void mockLoadUser({required DbUser dbUser}) {
    when(
      () => loadUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => dbUser);
  }

  void mockAddUser() {
    _mockDbUser();
    when(
      () => addUser(
        dbUser: any(named: 'dbUser'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUser({Object? throwable}) {
    if (throwable != null) {
      when(_updateUserCall).thenThrow(throwable);
    } else {
      when(_updateUserCall).thenAnswer((_) async => '');
    }
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockDbUser() {
    registerFallbackValue(FakeDbUser());
  }

  Future<void> _updateUserCall() {
    return updateUser(
      userId: any(named: 'userId'),
      isDarkModeOn: any(named: 'isDarkModeOn'),
      isDarkModeCompatibilityWithSystemOn:
          any(named: 'isDarkModeCompatibilityWithSystemOn'),
    );
  }
}
