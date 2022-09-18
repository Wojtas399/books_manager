import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/models/db_user.dart';
import 'package:app/domain/entities/user.dart';

class UserMapper {
  static User mapFromDbModelToEntity(DbUser dbUser) {
    return User(
      id: dbUser.id,
      isDarkModeOn: dbUser.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          dbUser.isDarkModeCompatibilityWithSystemOn,
    );
  }

  static DbUser mapFromEntityToDbModel(User user) {
    return DbUser(
      id: user.id,
      isDarkModeOn: user.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          user.isDarkModeCompatibilityWithSystemOn,
    );
  }

  static DbUser mapFromFirebaseModelToDbModel(FirebaseUser firebaseUser) {
    return DbUser(
      id: firebaseUser.id,
      isDarkModeOn: firebaseUser.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          firebaseUser.isDarkModeCompatibilityWithSystemOn,
    );
  }

  static FirebaseUser mapFromDbModelToFirebaseModel(DbUser dbUser) {
    return FirebaseUser(
      id: dbUser.id,
      isDarkModeOn: dbUser.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          dbUser.isDarkModeCompatibilityWithSystemOn,
    );
  }
}
