import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_database.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_tables.dart';
import 'package:app/data/models/db_book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class SqliteBookService {
  final Uuid _uuid = const Uuid();

  static String get tableCreationCommand => '''
      CREATE TABLE ${SqliteTables.booksTable} (
        ${SqliteBookFields.id} TEXT PRIMARY KEY NOT NULL,
        ${SqliteBookFields.userId} TEXT NOT NULL,
        ${SqliteBookFields.status} TEXT NOT NULL,
        ${SqliteBookFields.title} TEXT NOT NULL,
        ${SqliteBookFields.author} TEXT NOT NULL,
        ${SqliteBookFields.allPagesAmount} INTEGER NOT NULL,
        ${SqliteBookFields.readPagesAmount} INTEGER NOT NULL,
        ${SqliteBookFields.isDeleted} INTEGER NOT NULL
      )
    ''';

  Future<List<DbBook>> loadUserBooks({required String userId}) async {
    final List<Map<String, Object?>> booksJson = await _queryUserBooks(userId);
    return _convertBooksJsonsToDbBooks(booksJson);
  }

  Future<List<String>> loadIdsOfUserBooksMarkedAsDeleted({
    required String userId,
  }) async {
    final List<Map<String, Object?>> booksIdsJsons =
        await _queryIdsOfUserDeletedBooks(userId);
    return _convertBooksIdsJsonsToStrings(booksIdsJsons);
  }

  Future<DbBook> addBook({required DbBook dbBook}) async {
    final String bookId = dbBook.id ?? _generateNewId();
    final DbBook updatedBook = dbBook.copyWith(id: bookId);
    await _insertNewBook(
      updatedBook.toSqliteBook(isDeleted: false),
    );
    return updatedBook;
  }

  Future<void> markBookAsDeleted({required String bookId}) async {
    final Map<String, Object?> bookJson = await _queryBook(bookId);
    final SqliteBook sqliteBook = SqliteBook.fromJson(bookJson);
    final SqliteBook updatedSqliteBook = sqliteBook.copyWith(isDeleted: true);
    await _updateBook(updatedSqliteBook);
  }

  Future<void> deleteBook({required String bookId}) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.delete(
      SqliteTables.booksTable,
      where: '${SqliteBookFields.id} = ?',
      whereArgs: [bookId],
    );
  }

  Future<List<Map<String, Object?>>> _queryUserBooks(String userId) async {
    final Database db = await SqliteDatabase.instance.database;
    return await db.query(
      SqliteTables.booksTable,
      where:
          '${SqliteBookFields.userId} = ? AND ${SqliteBookFields.isDeleted} = ?',
      whereArgs: [userId, 0],
    );
  }

  Future<List<Map<String, Object?>>> _queryIdsOfUserDeletedBooks(
    String userId,
  ) async {
    final Database db = await SqliteDatabase.instance.database;
    return await db.query(
      SqliteTables.booksTable,
      columns: [SqliteBookFields.id],
      where:
          '${SqliteBookFields.userId} = ? AND ${SqliteBookFields.isDeleted} = ?',
      whereArgs: [userId, 1],
    );
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

  List<DbBook> _convertBooksJsonsToDbBooks(List<Map<String, Object?>> jsons) {
    return jsons
        .map(SqliteBook.fromJson)
        .map((SqliteBook sqliteBook) => sqliteBook.toDbBook())
        .toList();
  }

  List<String> _convertBooksIdsJsonsToStrings(
    List<Map<String, Object?>> jsons,
  ) {
    return jsons.map(SqliteBook.fromJsonToId).toList();
  }

  Future<void> _insertNewBook(SqliteBook sqliteBook) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.insert(SqliteTables.booksTable, sqliteBook.toJson());
  }

  String _generateNewId() {
    return _uuid.v4();
  }
}
