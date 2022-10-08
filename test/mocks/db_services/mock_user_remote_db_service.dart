import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class FakeUser extends Fake implements User {}

class MockUserRemoteDbService extends Mock implements UserRemoteDbService {
  void mockLoadUser({required User user}) {
    when(
      () => loadUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => user);
  }

  void mockAddUser() {
    _mockUser();
    when(
      () => addUser(
        user: any(named: 'user'),
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

  void _mockUser() {
    registerFallbackValue(FakeUser());
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
