import 'package:app/data/data_sources/user_data_source.dart';
import 'package:app/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class FakeUser extends Fake implements User {}

class MockUserDataSource extends Mock implements UserDataSource {
  void mockGetUser({required User user}) {
    when(
      () => getUser(
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

  void mockUpdateUser() {
    when(
      () => updateUser(
        userId: any(named: 'userId'),
        isDarkModeOn: any(named: 'isDarkModeOn'),
        isDarkModeCompatibilityWithSystemOn:
            any(named: 'isDarkModeCompatibilityWithSystemOn'),
      ),
    ).thenAnswer((_) async => '');
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
}
