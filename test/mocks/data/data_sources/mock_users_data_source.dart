import 'package:app/data/data_sources/users_data_source.dart';
import 'package:app/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class FakeUser extends Fake implements User {}

class MockUsersDataSource extends Mock implements UsersDataSource {
  void mockGetUserStream({required User user}) {
    when(
      () => getUserStream(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(user));
  }

  void mockAddUser() {
    _mockUser();
    when(
      () => addUser(
        user: any(named: 'user'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUser({required User updatedUser, Object? throwable}) {
    if (throwable != null) {
      when(_updateUserCall).thenThrow(throwable);
    } else {
      when(_updateUserCall).thenAnswer((_) async => updatedUser);
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

  Future<User> _updateUserCall() {
    return updateUser(
      userId: any(named: 'userId'),
      isDarkModeOn: any(named: 'isDarkModeOn'),
      isDarkModeCompatibilityWithSystemOn: any(
        named: 'isDarkModeCompatibilityWithSystemOn',
      ),
    );
  }
}
