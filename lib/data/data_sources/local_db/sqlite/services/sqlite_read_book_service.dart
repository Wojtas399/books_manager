import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_database.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_tables.dart';
import 'package:sqflite/sqflite.dart';

class SqliteReadBookService {
  static String get tableCreationCommand => '''
    CREATE TABLE ${SqliteTables.readBooksTable} (
      ${SqliteReadBookFields.userId} TEXT NOT NULL,
      ${SqliteReadBookFields.bookId} TEXT NOT NULL,
      ${SqliteReadBookFields.date} TEXT NOT NULL,
      ${SqliteReadBookFields.readPagesAmount} INTEGER NOT NULL
    )
  ''';

  Future<List<SqliteReadBook>> loadUserReadBooks({
    required String userId,
    String? date,
  }) async {
    final List<Map<String, Object?>> jsons = await _queryUserReadPages(
      userId: userId,
      date: date,
    );
    return jsons.map(SqliteReadBook.fromJson).toList();
  }

  Future<void> addReadBook({required SqliteReadBook sqliteReadBook}) async {
    await _insertReadBook(sqliteReadBook);
  }

  Future<void> updateReadBook({
    required SqliteReadBook updatedSqliteReadBook,
  }) async {
    await _updateReadBook(updatedSqliteReadBook);
  }

  Future<List<Map<String, Object?>>> _queryUserReadPages({
    required String userId,
    String? date,
  }) async {
    final Database database = await SqliteDatabase.instance.database;
    String query = 'SELECT * FROM ${SqliteTables.readBooksTable}';
    query += " WHERE ${SqliteReadBookFields.userId} = '$userId'";
    if (date != null) {
      query += " AND ${SqliteReadBookFields.date} = '$date'";
    }
    return await database.rawQuery(query);
  }

  Future<void> _insertReadBook(SqliteReadBook sqliteReadBook) async {
    final Database database = await SqliteDatabase.instance.database;
    await database.insert(
      SqliteTables.readBooksTable,
      sqliteReadBook.toJson(),
    );
  }

  Future<void> _updateReadBook(SqliteReadBook updatedSqliteReadBook) async {
    final Database database = await SqliteDatabase.instance.database;
    await database.update(
      SqliteTables.readBooksTable,
      updatedSqliteReadBook.toJson(),
      where:
          '${SqliteReadBookFields.userId} = ? AND ${SqliteReadBookFields.bookId} = ? AND ${SqliteReadBookFields.date} = ?',
      whereArgs: [
        updatedSqliteReadBook.userId,
        updatedSqliteReadBook.date,
        updatedSqliteReadBook.bookId,
      ],
    );
  }
}
