import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_book_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/day_mapper.dart';
import 'package:app/data/mappers/read_book_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/extensions/list_extensions.dart';
import 'package:app/providers/date_provider.dart';

class DayLocalDbService {
  late final SqliteReadBookService _sqliteReadBookService;
  late final DateProvider _dateProvider;

  DayLocalDbService({
    required SqliteReadBookService sqliteReadBookService,
    required DateProvider dateProvider,
  }) {
    _sqliteReadBookService = sqliteReadBookService;
    _dateProvider = dateProvider;
  }

  Future<List<DbDay>> loadUserDays({required String userId}) async {
    final List<SqliteReadBook> readBooks =
        await _loadUserReadBooks(userId: userId);
    return _segregateReadBooksIntoDbDays(readBooks);
  }

  Future<DbDay> addUserReadBook({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  }) async {
    final String todayDateStr = _getNowAsStr();
    final List<SqliteReadBook> readBooksFromToday =
        await _loadUserReadBooks(userId: userId, date: todayDateStr);
    final List<String> booksIds = readBooksFromToday
        .map((SqliteReadBook sqliteReadBook) => sqliteReadBook.bookId)
        .toList();
    if (booksIds.contains(bookId)) {
      final int readBookIndex = readBooksFromToday.indexWhere(
        (SqliteReadBook sqliteReadBook) => sqliteReadBook.bookId == bookId,
      );
      final SqliteReadBook updatedSqliteReadBook = await _updateReadBook(
        sqliteReadBook: readBooksFromToday[readBookIndex],
        readPagesAmountToAdd: readPagesAmount,
      );
      readBooksFromToday[readBookIndex] = updatedSqliteReadBook;
    } else {
      final SqliteReadBook addedSqliteReadBook = await _addReadBook(
        userId: userId,
        date: todayDateStr,
        bookId: bookId,
        readPagesAmount: readPagesAmount,
      );
      readBooksFromToday.add(addedSqliteReadBook);
    }
    return DayMapper.mapFromSqliteModelsToDbModel(readBooksFromToday);
  }

  Future<List<SqliteReadBook>> _loadUserReadBooks({
    required String userId,
    String? date,
  }) async {
    return await _sqliteReadBookService.loadUserReadBooks(
      userId: userId,
      date: date,
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

  Future<SqliteReadBook> _updateReadBook({
    required SqliteReadBook sqliteReadBook,
    required int readPagesAmountToAdd,
  }) async {
    final int readPagesAmount = sqliteReadBook.readPagesAmount;
    final int newReadPagesAmount = readPagesAmount + readPagesAmountToAdd;
    final SqliteReadBook updatedSqliteReadBook =
        sqliteReadBook.copyWithReadPagesAmount(newReadPagesAmount);
    await _sqliteReadBookService.updateReadBook(
      updatedSqliteReadBook: updatedSqliteReadBook,
    );
    return updatedSqliteReadBook;
  }

  Future<SqliteReadBook> _addReadBook({
    required String userId,
    required String date,
    required String bookId,
    required int readPagesAmount,
  }) async {
    final SqliteReadBook sqliteReadBook = SqliteReadBook(
      userId: userId,
      date: date,
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    await _sqliteReadBookService.addReadBook(sqliteReadBook: sqliteReadBook);
    return sqliteReadBook;
  }

  String _getNowAsStr() {
    return DateMapper.mapFromDateTimeToString(_dateProvider.getNow());
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
