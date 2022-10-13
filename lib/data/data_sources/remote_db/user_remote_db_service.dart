import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/domain/entities/user.dart';

class UserRemoteDbService {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;

  UserRemoteDbService({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
  }

  Future<User> loadUser({required String userId}) async {
    final FirebaseUser firebaseUser =
        await _firebaseFirestoreUserService.loadUser(userId: userId);
    return _createUser(firebaseUser);
  }

  Future<void> addUser({required User user}) async {
    final FirebaseUser firebaseUser = _createFirebaseUser(user);
    await _firebaseFirestoreUserService.addUser(firebaseUser: firebaseUser);
  }

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
