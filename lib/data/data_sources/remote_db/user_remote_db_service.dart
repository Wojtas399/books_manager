import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/mappers/user_mapper.dart';
import 'package:app/data/models/db_user.dart';

class UserRemoteDbService {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;

  UserRemoteDbService({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
  }

  Future<DbUser> loadUser({required String userId}) async {
    final FirebaseUser firebaseUser =
        await _firebaseFirestoreUserService.loadUser(userId: userId);
    return UserMapper.mapFromFirebaseModelToDbModel(firebaseUser);
  }

  Future<void> addUser({required DbUser dbUser}) async {
    final FirebaseUser firebaseUser =
        UserMapper.mapFromDbModelToFirebaseModel(dbUser);
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
}
