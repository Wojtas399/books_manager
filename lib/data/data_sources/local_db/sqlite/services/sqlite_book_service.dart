import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_database.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_tables.dart';
import 'package:sqflite/sqflite.dart';

class SqliteBookService {
  static String get tableCreationCommand => '''
      CREATE TABLE ${SqliteTables.booksTable} (
        ${SqliteBookFields.id} TEXT PRIMARY KEY NOT NULL,
        ${SqliteBookFields.userId} TEXT NOT NULL,
        ${SqliteBookFields.status} TEXT NOT NULL,
        ${SqliteBookFields.title} TEXT NOT NULL,
        ${SqliteBookFields.author} TEXT NOT NULL,
        ${SqliteBookFields.allPagesAmount} INTEGER NOT NULL,
        ${SqliteBookFields.readPagesAmount} INTEGER NOT NULL,
        ${SqliteBookFields.syncState} TEXT NOT NULL
      )
    ''';

  Future<SqliteBook> loadBook({required String bookId}) async {
    final Map<String, Object?> bookJson = await _queryBook(bookId);
    return SqliteBook.fromJson(bookJson);
  }

  Future<List<SqliteBook>> loadUserBooks({
    required String userId,
    String? bookStatus,
    SyncState? syncState,
  }) async {
    final List<Map<String, Object?>> booksInJson = await _queryUserBooks(
      userId: userId,
      bookStatus: bookStatus,
      syncState: syncState,
    );
    return booksInJson.map(SqliteBook.fromJson).toList();
  }

  Future<void> addBook({required SqliteBook sqliteBook}) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.insert(SqliteTables.booksTable, sqliteBook.toJson());
  }

  Future<SqliteBook> updateBook({
    required String bookId,
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    SyncState? syncState,
  }) async {
    final Map<String, Object?> bookJson = await _queryBook(bookId);
    final SqliteBook sqliteBook = SqliteBook.fromJson(bookJson);
    final SqliteBook updatedSqliteBook = sqliteBook.copyWith(
      status: status,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
      syncState: syncState,
    );
    await _updateBook(updatedSqliteBook);
    return updatedSqliteBook;
  }

  Future<void> deleteBook({required String bookId}) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.delete(
      SqliteTables.booksTable,
      where: '${SqliteBookFields.id} = ?',
      whereArgs: [bookId],
    );
  }

  Future<List<Map<String, Object?>>> _queryUserBooks({
    required String userId,
    String? bookStatus,
    SyncState? syncState,
  }) async {
    final Database db = await SqliteDatabase.instance.database;
    String query = "SELECT * FROM ${SqliteTables.booksTable}";
    query += " WHERE ${SqliteBookFields.userId} = '$userId'";
    if (bookStatus != null) {
      query += " AND ${SqliteBookFields.status} = '$bookStatus'";
    }
    if (syncState != null) {
      query += " AND ${SqliteBookFields.syncState} = '${syncState.name}'";
    } else {
      final String syncStates =
          "('${SyncState.none.name}', '${SyncState.added.name}', '${SyncState.updated.name}')";
      query += " AND ${SqliteBookFields.syncState} IN $syncStates";
    }
    return await db.rawQuery(query);
  }

  Future<Map<String, Object?>> _queryBook(String bookId) async {
    final Database db = await SqliteDatabase.instance.database;
    final List<Map<String, Object?>> jsons = await db.query(
      SqliteTables.booksTable,
      where: '${SqliteBookFields.id} = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    return jsons.first;
  }

  Future<void> _updateBook(SqliteBook sqliteBook) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.update(
      SqliteTables.booksTable,
      sqliteBook.toJson(),
      where: '${SqliteBookFields.id} = ?',
      whereArgs: [sqliteBook.id],
    );
  }
}
