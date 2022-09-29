import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/day_mapper.dart';
import 'package:app/data/mappers/read_book_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/extensions/list_extensions.dart';

class DayLocalDbService {
  late final SqliteReadBookService _sqliteReadBookService;

  DayLocalDbService({
    required SqliteReadBookService sqliteReadBookService,
  }) {
    _sqliteReadBookService = sqliteReadBookService;
  }

  Future<List<DbDay>> loadUserDays({
    required String userId,
    SyncState? syncState,
  }) async {
    final List<SqliteReadBook> readBooks =
        await _loadUserReadBooks(userId: userId, syncState: syncState);
    return _segregateReadBooksIntoDbDays(readBooks);
  }

  Future<DbDay> addUserReadBook({
    required DbReadBook dbReadBook,
    required String userId,
    required String date,
    SyncState syncState = SyncState.none,
  }) async {
    final SqliteReadBook sqliteReadBook = SqliteReadBook(
      userId: userId,
      date: date,
      bookId: dbReadBook.bookId,
      readPagesAmount: dbReadBook.readPagesAmount,
      syncState: syncState,
    );
    await _sqliteReadBookService.addReadBook(sqliteReadBook: sqliteReadBook);
    return await _loadUserDbDay(userId, date);
  }

  Future<DbDay> updateReadBook({
    required String userId,
    required String date,
    required String bookId,
    int? readPagesAmount,
    SyncState? syncState,
  }) async {
    await _sqliteReadBookService.updateReadBook(
      userId: userId,
      date: date,
      bookId: bookId,
      readPagesAmount: readPagesAmount,
      syncState: syncState,
    );
    return await _loadUserDbDay(userId, date);
  }

  Future<List<SqliteReadBook>> _loadUserReadBooks({
    required String userId,
    String? date,
    SyncState? syncState,
  }) async {
    return await _sqliteReadBookService.loadUserReadBooks(
      userId: userId,
      date: date,
      syncState: syncState,
    );
  }

  Future<DbDay> _loadUserDbDay(String userId, String date) async {
    final List<SqliteReadBook> userReadBooksFromDay = await _loadUserReadBooks(
      userId: userId,
      date: date,
    );
    return DbDay(
      userId: userId,
      date: date,
      readBooks: userReadBooksFromDay
          .map(ReadBookMapper.mapFromSqliteModelToDbModel)
          .toList(),
    );
  }

  List<DbDay> _segregateReadBooksIntoDbDays(List<SqliteReadBook> readBooks) {
    final List<DbDay> dbDays = [];
    final List<String> existingDates = [];
    for (final SqliteReadBook readBook in readBooks) {
      if (existingDates.doesNotContain(readBook.date)) {
        existingDates.add(readBook.date);
        final DbDay newDbDay = _createDbDayFromSqliteReadBook(readBook);
        dbDays.add(newDbDay);
      } else {
        final DbReadBook newDbReadBook =
            _createDbReadBookFromSqliteReadBook(readBook);
        final int dayIndex = dbDays.indexWhere(
          (DbDay dbDay) => dbDay.date == readBook.date,
        );
        final DbDay dbDay = dbDays[dayIndex];
        dbDays[dayIndex] = dbDay.copyWith(
          readBooks: [...dbDay.readBooks, newDbReadBook],
        );
      }
    }
    return dbDays;
  }

  DbDay _createDbDayFromSqliteReadBook(SqliteReadBook sqliteReadBook) {
    return DayMapper.mapFromSqliteModelsToDbModel([sqliteReadBook]);
  }

  DbReadBook _createDbReadBookFromSqliteReadBook(
    SqliteReadBook sqliteReadBook,
  ) {
    return ReadBookMapper.mapFromSqliteModelToDbModel(sqliteReadBook);
  }
}
