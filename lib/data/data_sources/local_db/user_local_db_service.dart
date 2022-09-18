import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_user_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/user_mapper.dart';
import 'package:app/data/models/db_user.dart';

class UserLocalDbService {
  late final SqliteUserService _sqliteUserService;

  UserLocalDbService({
    required SqliteUserService sqliteUserService,
  }) {
    _sqliteUserService = sqliteUserService;
  }

  Future<DbUser> loadUser({required String userId}) async {
    final SqliteUser sqliteUser = await _sqliteUserService.loadUser(
      userId: userId,
    );
    return UserMapper.mapFromSqliteModelToDbModel(sqliteUser);
  }

  Future<void> addUser({
    required DbUser dbUser,
    SyncState syncState = SyncState.none,
  }) async {
    final SqliteUser sqliteUser = UserMapper.mapFromDbModelToSqliteModel(
      dbUser,
      syncState,
    );
    await _sqliteUserService.addUser(sqliteUser: sqliteUser);
  }

  Future<DbUser> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    SyncState? syncState,
  }) async {
    final SqliteUser updatedSqliteUser = await _sqliteUserService.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      syncState: syncState,
    );
    return UserMapper.mapFromSqliteModelToDbModel(updatedSqliteUser);
  }

  Future<void> deleteUser({required String userId}) async {
    await _sqliteUserService.deleteUser(userId: userId);
  }
}
