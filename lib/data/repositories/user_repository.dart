import 'package:app/data/data_sources/firebase/entities/firebase_user.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class UserRepository implements UserInterface {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;

  UserRepository({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
  }

  @override
  Stream<User?> getUser({required String userId}) {
    return _firebaseFirestoreUserService.getUser(userId: userId).map(
      (FirebaseUser? firebaseUser) {
        return firebaseUser == null ? null : _createUser(firebaseUser);
      },
    );
  }

  @override
  Future<void> addUser({required User user}) async {
    final FirebaseUser firebaseUser = _createFirebaseUser(user);
    await _firebaseFirestoreUserService.addUser(firebaseUser: firebaseUser);
  }

  @override
  Future<void> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  @override
  Future<void> deleteUser({required String userId}) async {
    await _firebaseFirestoreUserService.deleteUser(userId: userId);
  }

  User _createUser(FirebaseUser firebaseUser) {
    return User(
      id: firebaseUser.id,
      isDarkModeOn: firebaseUser.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          firebaseUser.isDarkModeCompatibilityWithSystemOn,
    );
  }

  FirebaseUser _createFirebaseUser(User user) {
    return FirebaseUser(
      id: user.id,
      isDarkModeOn: user.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          user.isDarkModeCompatibilityWithSystemOn,
      daysOfReading: const [],
    );
  }
}
