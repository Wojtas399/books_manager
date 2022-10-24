import 'package:app/data/data_sources/firebase/entities/firebase_user.dart';
import 'package:app/data/data_sources/firebase/services/firebase_database_users_service.dart';
import 'package:app/domain/entities/user.dart';

class UsersDataSource {
  late final FirebaseDatabaseUsersService _firebaseDatabaseUsersService;

  UsersDataSource({
    required FirebaseDatabaseUsersService firebaseDatabaseUsersService,
  }) {
    _firebaseDatabaseUsersService = firebaseDatabaseUsersService;
  }

  Stream<User?> getUserStream({required String userId}) {
    return _firebaseDatabaseUsersService.getUserStream(userId: userId).map(
      (FirebaseUser? firebaseUser) {
        return firebaseUser != null ? _createUser(firebaseUser) : null;
      },
    );
  }

  Future<void> addUser({required User user}) async {
    final FirebaseUser firebaseUser = _createFirebaseUser(user);
    await _firebaseDatabaseUsersService.addUser(firebaseUser: firebaseUser);
  }

  Future<User> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    final FirebaseUser updatedFirebaseUser =
        await _firebaseDatabaseUsersService.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
    final User updatedUser = _createUser(updatedFirebaseUser);
    return updatedUser;
  }

  Future<void> deleteUser({required String userId}) async {
    await _firebaseDatabaseUsersService.deleteUser(userId: userId);
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
    );
  }
}
