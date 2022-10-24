import 'package:app/data/data_sources/firebase/entities/firebase_user.dart';
import 'package:app/data/data_sources/firebase/services/firebase_database_users_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeFirebaseUser extends Fake implements FirebaseUser {}

class MockFirebaseDatabaseUsersService extends Mock
    implements FirebaseDatabaseUsersService {
  void mockGetUserStream({required FirebaseUser firebaseUser}) {
    when(
      () => getUserStream(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(firebaseUser));
  }

  void mockAddUser() {
    _mockFirebaseUser();
    when(
      () => addUser(
        firebaseUser: any(named: 'firebaseUser'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUser({required FirebaseUser updatedFirebaseUser}) {
    when(
      () => updateUser(
        userId: any(named: 'userId'),
        isDarkModeOn: any(named: 'isDarkModeOn'),
        isDarkModeCompatibilityWithSystemOn: any(
          named: 'isDarkModeCompatibilityWithSystemOn',
        ),
      ),
    ).thenAnswer((_) async => updatedFirebaseUser);
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockFirebaseUser() {
    registerFallbackValue(FakeFirebaseUser());
  }
}
