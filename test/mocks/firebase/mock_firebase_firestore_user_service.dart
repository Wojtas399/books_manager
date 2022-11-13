import 'package:app/data/firebase/entities/firebase_user.dart';
import 'package:app/data/firebase/services/firebase_firestore_user_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeFirebaseUser extends Fake implements FirebaseUser {}

class MockFirebaseFirestoreUserService extends Mock
    implements FirebaseFirestoreUserService {
  void mockGetUser({required FirebaseUser? firebaseUser}) {
    when(
      () => getUser(
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

  void mockUpdateUser() {
    when(
      () => updateUser(
        userId: any(named: 'userId'),
        isDarkModeOn: any(named: 'isDarkModeOn'),
        isDarkModeCompatibilityWithSystemOn:
            any(named: 'isDarkModeCompatibilityWithSystemOn'),
        daysOfReading: any(named: 'daysOfReading'),
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

  void _mockFirebaseUser() {
    registerFallbackValue(FakeFirebaseUser());
  }
}
