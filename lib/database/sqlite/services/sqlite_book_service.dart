import 'package:sqflite/sqflite.dart';

import '../entities/sqlite_book.dart';
import '../sqlite_database.dart';
import '../sqlite_tables.dart';

class SqliteBookService {
  static String get tableCreationCommand => '''
      CREATE TABLE ${SqliteTables.booksTable} (
        ${SqliteBookFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${SqliteBookFields.userId} TEXT NOT NULL,
        ${SqliteBookFields.status} TEXT NOT NULL,
        ${SqliteBookFields.image} TEXT,
        ${SqliteBookFields.title} TEXT NOT NULL,
        ${SqliteBookFields.author} TEXT NOT NULL,
        ${SqliteBookFields.allPagesAmount} INTEGER NOT NULL,
        ${SqliteBookFields.readPagesAmount} INTEGER NOT NULL
      )
    ''';

  Future<List<SqliteBook>> loadBooksByUserId({
    required String userId,
  }) async {
    final Database db = await SqliteDatabase.instance.database;
    final List<Map<String, Object?>> booksAsJson = await db.query(
      SqliteTables.booksTable,
      where: '${SqliteBookFields.userId} = ?',
      whereArgs: [userId],
    );
    return booksAsJson
        .map((Map<String, Object?> json) => SqliteBook.fromJson(json))
        .toList();
  }

  Future<SqliteBook> addNewBook(SqliteBook book) async {
    final Database db = await SqliteDatabase.instance.database;
    final int bookId = await db.insert(
      SqliteTables.booksTable,
      book.toJson(),
    );
    return book.copyWith(id: bookId);
  }
}
