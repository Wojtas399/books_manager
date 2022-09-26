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

  Future<SqliteReadPages?> loadReadPages({
    required String userId,
    required String date,
    required String bookId,
  }) async {
    final List<Map<String, Object?>> jsons = await _queryUserReadPages(
      userId: userId,
      date: date,
      bookId: bookId,
    );
    if (jsons.isNotEmpty) {
      return SqliteReadPages.fromJson(jsons.first);
    } else {
      return null;
    }
  }

  Future<List<SqliteReadPages>> loadListOfReadPagesByUserId({
    required String userId,
  }) async {
    final List<Map<String, Object?>> jsons =
        await _queryUserReadPages(userId: userId);
    return jsons.map(SqliteReadPages.fromJson).toList();
  }

  Future<void> addReadPages({required SqliteReadPages sqliteReadPages}) async {
    await _insertReadPages(sqliteReadPages);
  }

  Future<void> updateReadPages({
    required SqliteReadPages updatedReadPages,
  }) async {
    await _updateReadPages(updatedReadPages);
  }

  Future<List<Map<String, Object?>>> _queryUserReadPages({
    required String userId,
    String? date,
    String? bookId,
  }) async {
    final Database database = await SqliteDatabase.instance.database;
    String query = 'SELECT * FROM ${SqliteTables.readPagesTable}';
    query += " WHERE ${SqliteReadPagesFields.userId} = '$userId'";
    if (date != null) {
      query += " AND ${SqliteReadPagesFields.date} = '$date'";
    }
    if (bookId != null) {
      query += " AND ${SqliteReadPagesFields.bookId} = '$bookId'";
    }
    return await database.rawQuery(query);
  }

  Future<void> _insertReadPages(SqliteReadPages readPages) async {
    final Database database = await SqliteDatabase.instance.database;
    await database.insert(
      SqliteTables.readPagesTable,
      readPages.toJson(),
    );
  }

  Future<void> _updateReadPages(SqliteReadPages updatedReadPages) async {
    final Database database = await SqliteDatabase.instance.database;
    await database.update(
      SqliteTables.readPagesTable,
      updatedReadPages.toJson(),
      where:
          '${SqliteReadPagesFields.userId} = ? AND ${SqliteReadPagesFields.bookId} = ? AND ${SqliteReadPagesFields.date} = ?',
      whereArgs: [
        updatedReadPages.userId,
        updatedReadPages.date,
        updatedReadPages.bookId,
      ],
    );
  }
}
