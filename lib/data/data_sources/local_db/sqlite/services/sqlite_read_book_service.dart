import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_database.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_tables.dart';
import 'package:sqflite/sqflite.dart';

class SqliteReadBookService {
  static String get tableCreationCommand => '''
    CREATE TABLE ${SqliteTables.readBooksTable} (
      ${SqliteReadBookFields.userId} TEXT NOT NULL,
      ${SqliteReadBookFields.bookId} TEXT NOT NULL,
      ${SqliteReadBookFields.date} TEXT NOT NULL,
      ${SqliteReadBookFields.readPagesAmount} INTEGER NOT NULL,
      ${SqliteReadBookFields.syncState} TEXT NOT NULL
    )
  ''';

  Future<SqliteReadBook?> loadReadBook({
    required String userId,
    required String date,
    required String bookId,
  }) async {
    final Map<String, Object?>? json = await _queryReadBook(
      userId: userId,
      date: date,
      bookId: bookId,
    );
    if (json == null) {
      return null;
    }
    return SqliteReadBook.fromJson(json);
  }

  Future<List<SqliteReadBook>> loadUserReadBooks({
    required String userId,
    String? date,
    String? bookId,
    SyncState? syncState,
  }) async {
    final List<Map<String, Object?>> jsons = await _queryUserReadBooks(
      userId: userId,
      date: date,
      bookId: bookId,
      syncState: syncState,
    );
    return jsons.map(SqliteReadBook.fromJson).toList();
  }

  Future<List<SqliteReadBook>> loadUserReadBooksFromMonth({
    required String userId,
    required int month,
    required int year,
  }) async {
    final List<Map<String, Object?>> jsons = await _queryUserReadBooksByMonth(
      userId: userId,
      month: month,
      year: year,
    );
    return jsons.map(SqliteReadBook.fromJson).toList();
  }

  Future<void> addReadBook({required SqliteReadBook sqliteReadBook}) async {
    await _insertReadBook(sqliteReadBook);
  }

  Future<void> updateReadBook({
    required String userId,
    required String date,
    required String bookId,
    int? readPagesAmount,
    SyncState? syncState,
  }) async {
    final SqliteReadBook? sqliteReadBook = await loadReadBook(
      userId: userId,
      date: date,
      bookId: bookId,
    );
    if (sqliteReadBook == null) {
      throw 'Cannot load read book from sqlite';
    }
    final SqliteReadBook updatedSqliteReadBook = sqliteReadBook.copyWith(
      readPagesAmount: readPagesAmount,
      syncState: syncState,
    );
    await _updateReadBook(updatedSqliteReadBook);
  }

  Future<void> updateReadBooksSyncState({
    required String userId,
    required String date,
    required SyncState syncState,
  }) async {
    final Database database = await SqliteDatabase.instance.database;
    String query = "UPDATE ${SqliteTables.readBooksTable}";
    query += " SET ${SqliteReadBookFields.syncState} = '${syncState.name}'";
    query += " WHERE ${SqliteReadBookFields.userId} = '$userId'";
    query += " AND ${SqliteReadBookFields.date} = '$date'";
    await database.rawQuery(query);
  }

  Future<void> deleteReadBooksFromDate({
    required String userId,
    required String date,
  }) async {
    await _deleteReadBooks(
      userId: userId,
      date: date,
    );
  }

  Future<void> deleteReadBook({
    required String userId,
    required String date,
    required String bookId,
  }) async {
    await _deleteReadBooks(
      userId: userId,
      date: date,
      bookId: bookId,
    );
  }

  Future<List<Map<String, Object?>>> _queryUserReadBooks({
    required String userId,
    String? date,
    String? bookId,
    SyncState? syncState,
  }) async {
    final Database database = await SqliteDatabase.instance.database;
    String query = _createBasicQuery(userId: userId, syncState: syncState);
    if (date != null) {
      query += " AND ${SqliteReadBookFields.date} = '$date'";
    }
    if (bookId != null) {
      query += " AND ${SqliteReadBookFields.bookId} = '$bookId'";
    }
    return await database.rawQuery(query);
  }

  Future<List<Map<String, Object?>>> _queryUserReadBooksByMonth({
    required String userId,
    required int month,
    required int year,
  }) async {
    final Database database = await SqliteDatabase.instance.database;
    String query = _createBasicQuery(userId: userId);
    query += " AND ${SqliteReadBookFields.date} LIKE '%-$month-$year'";
    return await database.rawQuery(query);
  }

  Future<Map<String, Object?>?> _queryReadBook({
    required String userId,
    required String date,
    required String bookId,
  }) async {
    final List<Map<String, Object?>> jsons = await _queryUserReadBooks(
      userId: userId,
      date: date,
      bookId: bookId,
    );
    if (jsons.isNotEmpty) {
      return jsons.first;
    }
    return null;
  }

  String _createBasicQuery({required String userId, SyncState? syncState}) {
    String query = 'SELECT * FROM ${SqliteTables.readBooksTable}';
    query += " WHERE ${SqliteReadBookFields.userId} = '$userId'";
    if (syncState != null) {
      query += " AND ${SqliteReadBookFields.syncState} = '${syncState.name}'";
    } else {
      query +=
          " AND ${SqliteReadBookFields.syncState} IN ('${SyncState.none.name}', '${SyncState.added.name}', '${SyncState.updated.name}')";
    }
    return query;
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
          '${SqliteReadBookFields.userId} = ? AND ${SqliteReadBookFields.date} = ? AND ${SqliteReadBookFields.bookId} = ?',
      whereArgs: [
        updatedSqliteReadBook.userId,
        updatedSqliteReadBook.date,
        updatedSqliteReadBook.bookId,
      ],
    );
  }

  Future<void> _deleteReadBooks({
    required String userId,
    String? date,
    String? bookId,
  }) async {
    final Database database = await SqliteDatabase.instance.database;
    String query = "DELETE FROM ${SqliteTables.readBooksTable}";
    query += " WHERE ${SqliteReadBookFields.userId} = '$userId'";
    if (date != null) {
      query += " AND ${SqliteReadBookFields.date} = '$date'";
    }
    if (bookId != null) {
      query += " AND ${SqliteReadBookFields.bookId} = '$bookId'";
    }
    await database.rawQuery(query);
  }
}
