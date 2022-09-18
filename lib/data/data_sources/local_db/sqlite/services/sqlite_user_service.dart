import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_database.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_tables.dart';
import 'package:sqflite/sqflite.dart';

class SqliteUserService {
  static String get tableCreationCommand => '''
    CREATE TABLE ${SqliteTables.usersTable} (
      ${SqliteUserFields.id} TEXT PRIMARY KEY NOT NULL,
      ${SqliteUserFields.isDarkModeOn} INTEGER NOT NULL,
      ${SqliteUserFields.isDarkModeCompatibilityWithSystemOn} INTEGER NOT NULL,
      ${SqliteUserFields.syncState} TEXT NOT NULL
    )
  ''';

  Future<SqliteUser> loadUser({required String userId}) async {
    final Map<String, Object?> userJson = await _queryUser(userId);
    return SqliteUser.fromJson(userJson);
  }

  Future<void> addUser({required SqliteUser sqliteUser}) async {
    await _insertUser(sqliteUser);
  }

  Future<SqliteUser> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    SyncState? syncState,
  }) async {
    final Map<String, Object?> userJson = await _queryUser(userId);
    final SqliteUser sqliteUser = SqliteUser.fromJson(userJson);
    final SqliteUser updatedSqliteUser = sqliteUser.copyWith(
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      syncState: syncState,
    );
    await _updateUser(updatedSqliteUser);
    return updatedSqliteUser;
  }

  Future<void> deleteUser({required String userId}) async {
    await _deleteUser(userId);
  }

  Future<Map<String, Object?>> _queryUser(String userId) async {
    final Database db = await SqliteDatabase.instance.database;
    final List<Map<String, Object?>> rows = await db.query(
      SqliteTables.usersTable,
      where: '${SqliteUserFields.id} = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      return rows.first;
    } else {
      throw 'Cannot load user from sqlite';
    }
  }

  Future<void> _insertUser(SqliteUser sqliteUser) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.insert(
      SqliteTables.usersTable,
      sqliteUser.toJson(),
    );
  }

  Future<void> _updateUser(SqliteUser updatedSqliteUser) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.update(
      SqliteTables.usersTable,
      updatedSqliteUser.toJson(),
      where: '${SqliteUserFields.id} = ?',
      whereArgs: [updatedSqliteUser.id],
    );
  }

  Future<void> _deleteUser(String userId) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.delete(
      SqliteTables.usersTable,
      where: '${SqliteUserFields.id} = ?',
      whereArgs: [userId],
    );
  }
}
