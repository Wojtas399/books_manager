import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_database.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_tables.dart';
import 'package:sqflite/sqflite.dart';

class SqliteReadPagesService {
  static String get tableCreationCommand => '''
    CREATE TABLE ${SqliteTables.readPagesTable} (
      ${SqliteReadPagesFields.userId} TEXT NOT NULL,
      ${SqliteReadPagesFields.bookId} TEXT NOT NULL,
      ${SqliteReadPagesFields.date} TEXT NOT NULL,
      ${SqliteReadPagesFields.readPagesAmount} INTEGER NOT NULL
    )
  ''';

  Future<List<SqliteReadPages>> loadReadPagesByUserId({
    required String userId,
  }) async {
    final List<Map<String, Object?>> jsons =
        await _queryReadPagesByUserId(userId);
    return jsons.map(SqliteReadPages.fromJson).toList();
  }

  Future<void> addReadPages({required SqliteReadPages readPages}) async {
    await _insertReadPages(readPages);
  }

  Future<List<Map<String, Object?>>> _queryReadPagesByUserId(
    String userId,
  ) async {
    final Database database = await SqliteDatabase.instance.database;
    return await database.query(
      SqliteTables.readPagesTable,
      where: '${SqliteReadPagesFields.userId} = ?',
      whereArgs: [userId],
    );
  }

  Future<void> _insertReadPages(SqliteReadPages readPages) async {
    final Database database = await SqliteDatabase.instance.database;
    await database.insert(
      SqliteTables.readPagesTable,
      readPages.toJson(),
    );
  }
}
