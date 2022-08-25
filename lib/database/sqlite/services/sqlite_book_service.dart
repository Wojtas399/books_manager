import 'package:sqflite/sqflite.dart';

import '../entities/sqlite_book.dart';
import '../sqlite_database.dart';
import '../sqlite_tables.dart';
import '../sqlite_types.dart';

class SqliteBookService {
  static String get tableCreationCommand => '''
      CREATE TABLE ${SqliteTables.booksTable} (
        ${SqliteBookFields.id} ${SqliteTypes.idType},
        ${SqliteBookFields.userId} ${SqliteTypes.textType},
        ${SqliteBookFields.title} ${SqliteTypes.textType},
        ${SqliteBookFields.author} ${SqliteTypes.textType},
        ${SqliteBookFields.allPagesAmount} ${SqliteTypes.integerType},
        ${SqliteBookFields.readPagesAmount} ${SqliteTypes.integerType}
      )
    ''';

  Future<SqliteBook> addNewBook(SqliteBook book) async {
    final Database db = await SqliteDatabase.instance.database;
    final int bookId = await db.insert(
      SqliteTables.booksTable,
      book.toJson(),
    );
    return book.copyWith(id: bookId);
  }
}
