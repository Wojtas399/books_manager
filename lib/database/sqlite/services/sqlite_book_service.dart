import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../entities/db_book.dart';
import '../sqlite_database.dart';
import '../sqlite_tables.dart';

class SqliteBookService {
  final Uuid _uuid = const Uuid();

  static String get tableCreationCommand => '''
      CREATE TABLE ${SqliteTables.booksTable} (
        ${DatabaseBookFields.id} TEXT PRIMARY KEY NOT NULL,
        ${DatabaseBookFields.userId} TEXT NOT NULL,
        ${DatabaseBookFields.status} TEXT NOT NULL,
        ${DatabaseBookFields.image} TEXT,
        ${DatabaseBookFields.title} TEXT NOT NULL,
        ${DatabaseBookFields.author} TEXT NOT NULL,
        ${DatabaseBookFields.allPagesAmount} INTEGER NOT NULL,
        ${DatabaseBookFields.readPagesAmount} INTEGER NOT NULL
      )
    ''';

  Future<List<DbBook>> loadBooksByUserId({
    required String userId,
  }) async {
    final Database db = await SqliteDatabase.instance.database;
    final List<Map<String, Object?>> booksAsJson = await db.query(
      SqliteTables.booksTable,
      where: '${DatabaseBookFields.userId} = ?',
      whereArgs: [userId],
    );
    return booksAsJson
        .map((Map<String, Object?> json) => DbBook.fromSqliteJson(json))
        .toList();
  }

  Future<DbBook> addNewBook(DbBook dbBook) async {
    final Database db = await SqliteDatabase.instance.database;
    final String id = _uuid.v4();
    final DbBook newBook = dbBook.copyWith(id: id);
    await db.insert(
      SqliteTables.booksTable,
      newBook.toSqliteJson(),
    );
    return newBook;
  }
}
