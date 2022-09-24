import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/mappers/user_mapper.dart';
import 'package:app/data/models/db_user.dart';
import 'package:app/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const bool isDarkModeOn = false;
  const bool isDarkModeCompatibilityWithSystemOn = true;
  const SyncState syncState = SyncState.added;
  const User entity = User(
    id: userId,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
  );
  const DbUser dbModel = DbUser(
    id: userId,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
  );
  const SqliteUser sqliteModel = SqliteUser(
    id: userId,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    syncState: syncState,
  );
  const FirebaseUser firebaseModel = FirebaseUser(
    id: userId,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    daysOfReading: [],
  );

  test(
    'map from db model to entity',
    () {
      final User mappedEntity = UserMapper.mapFromDbModelToEntity(dbModel);

      expect(mappedEntity, entity);
    },
  );

  test(
    'map from entity to db model',
    () {
      final DbUser mappedDbModel = UserMapper.mapFromEntityToDbModel(entity);

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from sqlite model to db model',
    () {
      final DbUser mappedDbModel = UserMapper.mapFromSqliteModelToDbModel(
        sqliteModel,
      );

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to sqlite model',
    () {
      final SqliteUser mappedSqliteModel =
          UserMapper.mapFromDbModelToSqliteModel(dbModel, syncState);

      expect(mappedSqliteModel, sqliteModel);
    },
  );

  test(
    'map from firebase model to db model',
    () {
      final DbUser mappedDbModel = UserMapper.mapFromFirebaseModelToDbModel(
        firebaseModel,
      );

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to firebase model, without days of reading',
    () {
      final FirebaseUser mappedFirebaseModel =
          UserMapper.mapFromDbModelToFirebaseModel(dbUser: dbModel);

      expect(mappedFirebaseModel, firebaseModel);
    },
  );

  test(
    'map from db model to firebase model, with days of reading',
    () {
      final List<FirebaseDay> firebaseDays = [
        createFirebaseDay(date: '22-09-2022'),
        createFirebaseDay(date: '20-09-2022'),
      ];
      final FirebaseUser mappedFirebaseModel =
          UserMapper.mapFromDbModelToFirebaseModel(
        dbUser: dbModel,
        daysOfReading: firebaseDays,
      );

      expect(
        mappedFirebaseModel,
        firebaseModel.copyWith(daysOfReading: firebaseDays),
      );
    },
  );
}
