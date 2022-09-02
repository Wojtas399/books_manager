import 'package:app/data/data_sources/local_db/sqlite/sqlite_database.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_tables.dart';
import 'package:app/data/models/db_book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class SqliteBookService {
  final Uuid _uuid = const Uuid();

  static String get tableCreationCommand => '''
      CREATE TABLE ${SqliteTables.booksTable} (
        ${DbBookFields.id} TEXT PRIMARY KEY NOT NULL,
        ${DbBookFields.userId} TEXT NOT NULL,
        ${DbBookFields.status} TEXT NOT NULL,
        ${DbBookFields.title} TEXT NOT NULL,
        ${DbBookFields.author} TEXT NOT NULL,
        ${DbBookFields.allPagesAmount} INTEGER NOT NULL,
        ${DbBookFields.readPagesAmount} INTEGER NOT NULL
      )
    ''';

  Future<List<DbBook>> loadBooksByUserId({
    required String userId,
  }) async {
    final List<Map<String, Object?>> booksJson = await _queryUserBooks(userId);
    return booksJson.map(_createDbBookFromJson).toList();
  }

  Future<DbBook> addBook({required DbBook dbBook}) async {
    final String bookId = dbBook.id ?? _generateNewId();
    final DbBook updatedBook = dbBook.copyWith(id: bookId);
    await _insertNewBook(updatedBook);
    return updatedBook;
  }

  Future<List<Map<String, Object?>>> _queryUserBooks(String userId) async {
    final Database db = await SqliteDatabase.instance.database;
    return await db.query(
      SqliteTables.booksTable,
      where: '${DbBookFields.userId} = ?',
      whereArgs: [userId],
    );
  }

  DbBook _createDbBookFromJson(Map<String, Object?> json) {
    return DbBook.fromSqliteJson(json);
  }

  String _generateNewId() {
    return _uuid.v4();
  }

  Future<void> _insertNewBook(DbBook book) async {
    final Database db = await SqliteDatabase.instance.database;
    await db.insert(SqliteTables.booksTable, book.toSqliteJson());
  }
}
