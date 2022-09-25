import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_pages_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_user_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  static final SqliteDatabase instance = SqliteDatabase._init();

  static Database? _database;

  SqliteDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initializeDatabase('data.db');
    return _database!;
  }

  Future<void> close() async {
    final Database database = await instance.database;
    database.close();
  }

  Future<Database> _initializeDatabase(String filePath) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(SqliteUserService.tableCreationCommand);
    await db.execute(SqliteBookService.tableCreationCommand);
    await db.execute(SqliteReadPagesService.tableCreationCommand);
  }
}
