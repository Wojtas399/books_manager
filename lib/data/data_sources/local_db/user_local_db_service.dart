import 'package:app/config/errors.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_user_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/models/error.dart';

class UserLocalDbService {
  late final SqliteUserService _sqliteUserService;

  UserLocalDbService({
    required SqliteUserService sqliteUserService,
  }) {
    _sqliteUserService = sqliteUserService;
  }

  Future<bool> doesUserExist({required String userId}) async {
    return await _sqliteUserService.loadUser(userId: userId) != null;
  }

  Future<User> loadUser({required String userId}) async {
    final SqliteUser sqliteUser = await _loadUserFromSqlite(userId);
    return _createUser(sqliteUser);
  }

  Future<SyncState> loadUserSyncState({required String userId}) async {
    final SqliteUser sqliteUser = await _loadUserFromSqlite(userId);
    return sqliteUser.syncState;
  }

  Future<void> addUser({
    required User user,
    SyncState syncState = SyncState.none,
  }) async {
    final SqliteUser sqliteUser = _createSqliteUser(user, syncState);
    await _sqliteUserService.addUser(sqliteUser: sqliteUser);
  }

  Future<User> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    SyncState? syncState,
  }) async {
    final SqliteUser? updatedSqliteUser = await _sqliteUserService.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      syncState: syncState,
    );
    if (updatedSqliteUser != null) {
      return _createUser(updatedSqliteUser);
    } else {
      throw const UserError(code: UserErrorCode.updateFailure);
    }
  }

  Future<void> deleteUser({required String userId}) async {
    await _sqliteUserService.deleteUser(userId: userId);
  }

  Future<SqliteUser> _loadUserFromSqlite(String userId) async {
    final SqliteUser? sqliteUser = await _sqliteUserService.loadUser(
      userId: userId,
    );
    if (sqliteUser != null) {
      return sqliteUser;
    } else {
      throw const UserError(code: UserErrorCode.userNotFound);
    }
  }

  User _createUser(SqliteUser sqliteUser) {
    return User(
      id: sqliteUser.id,
      isDarkModeOn: sqliteUser.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          sqliteUser.isDarkModeCompatibilityWithSystemOn,
    );
  }

  SqliteUser _createSqliteUser(User user, SyncState syncState) {
    return SqliteUser(
      id: user.id,
      isDarkModeOn: user.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          user.isDarkModeCompatibilityWithSystemOn,
      syncState: syncState,
    );
  }
}
