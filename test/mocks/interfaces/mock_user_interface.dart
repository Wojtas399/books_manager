import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:mocktail/mocktail.dart';

class FakeUser extends Fake implements User {}

class MockUserInterface extends Mock implements UserInterface {
  void mockInitializeUser() {
    when(
      () => initializeUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockGetUser({User? user}) {
    when(
      () => getUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(user));
  }

  void mockLoadUser() {
    when(
      () => loadUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockAddUser() {
    _mockUser();
    when(
      () => addUser(
        user: any(named: 'user'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUserThemeSettings() {
    when(
      () => updateUserThemeSettings(
        userId: any(named: 'userId'),
        isDarkModeOn: any(named: 'isDarkModeOn'),
        isDarkModeCompatibilityWithSystemOn: any(
          named: 'isDarkModeCompatibilityWithSystemOn',
        ),
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
