import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/extensions/list_extensions.dart';

class DayLocalDbService {
  late final SqliteReadBookService _sqliteReadBookService;

  DayLocalDbService({
    required SqliteReadBookService sqliteReadBookService,
  }) {
    _sqliteReadBookService = sqliteReadBookService;
  }

  Future<List<Day>> loadUserDays({
    required String userId,
    SyncState? syncState,
  }) async {
    final List<SqliteReadBook> userReadBooks =
        await _sqliteReadBookService.loadUserReadBooks(
      userId: userId,
      syncState: syncState,
    );
    return _segregateReadBooksIntoDbDays(userReadBooks);
  }

  Future<List<Day>> loadUserDaysFromMonth({
    required String userId,
    required int month,
    required int year,
  }) async {
    final List<SqliteReadBook> userReadBooksFromMonth =
        await _sqliteReadBookService.loadUserReadBooksFromMonth(
      userId: userId,
      month: month,
      year: year,
    );
    return _segregateReadBooksIntoDbDays(userReadBooksFromMonth);
  }

  Future<void> addDay({
    required Day day,
    SyncState syncState = SyncState.none,
  }) async {
    for (final ReadBook readBook in day.readBooks) {
      final SqliteReadBook sqliteReadBook = _createSqliteReadBook(
        readBook,
        day.userId,
        day.date,
        syncState,
      );
      await _sqliteReadBookService.addReadBook(sqliteReadBook: sqliteReadBook);
    }
  }

  Future<void> updateDay({
    required Day updatedDay,
    SyncState syncState = SyncState.none,
  }) async {
    for (final ReadBook readBook in updatedDay.readBooks) {
      await _sqliteReadBookService.updateReadBook(
        userId: updatedDay.userId,
        date: DateMapper.mapFromDateTimeToString(updatedDay.date),
        bookId: readBook.bookId,
        readPagesAmount: readBook.readPagesAmount,
        syncState: syncState,
      );
    }
  }

  Future<void> deleteDay({
    required String userId,
    required DateTime date,
  }) async {
    await _sqliteReadBookService.deleteReadBooksFromDate(
      userId: userId,
      date: DateMapper.mapFromDateTimeToString(date),
    );
  }

  List<Day> _segregateReadBooksIntoDbDays(
    List<SqliteReadBook> sqliteReadBooks,
  ) {
    final List<Day> days = [];
    final List<String> existingDates = [];
    for (final SqliteReadBook sqliteReadBook in sqliteReadBooks) {
      if (existingDates.doesNotContain(sqliteReadBook.date)) {
        existingDates.add(sqliteReadBook.date);
        final Day newDay = _createDay(sqliteReadBook);
        days.add(newDay);
      } else {
        final ReadBook newReadBook = _createReadBook(sqliteReadBook);
        final DateTime date =
            DateMapper.mapFromStringToDateTime(sqliteReadBook.date);
        final int dayIndex = days.indexWhere((Day day) => day.date == date);
        days[dayIndex] = _addReadBookToDay(newReadBook, days[dayIndex]);
      }
    }
    return days;
  }

  Day _createDay(SqliteReadBook sqliteReadBook) {
    return Day(
      userId: sqliteReadBook.userId,
      date: DateMapper.mapFromStringToDateTime(sqliteReadBook.date),
      readBooks: [
        _createReadBook(sqliteReadBook),
      ],
    );
  }

  ReadBook _createReadBook(SqliteReadBook sqliteReadBook) {
    return ReadBook(
      bookId: sqliteReadBook.bookId,
      readPagesAmount: sqliteReadBook.readPagesAmount,
    );
  }

  SqliteReadBook _createSqliteReadBook(
    ReadBook readBook,
    String userId,
    DateTime date,
    SyncState syncState,
  ) {
    return SqliteReadBook(
      userId: userId,
      date: DateMapper.mapFromDateTimeToString(date),
      bookId: readBook.bookId,
      readPagesAmount: readBook.readPagesAmount,
      syncState: syncState,
    );
  }

  Day _addReadBookToDay(ReadBook readBook, Day day) {
    return day.copyWith(
      readBooks: [...day.readBooks, readBook],
    );
  }
}
