import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/day/add_new_read_book_to_user_days_use_case.dart';
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
    required String userId,
    required DateTime date,
    List<ReadBook>? readBooks,
    SyncState? syncState,
  }) async {
    if (readBooks != null) {
      final String dateAsStr = DateMapper.mapFromDateTimeToString(date);
      await _updateReadBooks(userId, dateAsStr, readBooks, syncState);
      await _deleteUnusedReadBooksFromDay(userId, dateAsStr, readBooks);
    } else if (syncState != null) {
      await _sqliteReadBookService.updateReadBooksSyncState(
        userId: userId,
        date: DateMapper.mapFromDateTimeToString(date),
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

  Future<void> _updateReadBooks(
    String userId,
    String date,
    List<ReadBook> updatedReadBooks,
    SyncState? syncState,
  ) async {
    for (final ReadBook readBook in updatedReadBooks) {
      await _sqliteReadBookService.updateReadBook(
        userId: userId,
        date: date,
        bookId: readBook.bookId,
        readPagesAmount: readBook.readPagesAmount,
        syncState: syncState,
      );
    }
  }

  Future<void> _deleteUnusedReadBooksFromDay(
    String userId,
    String date,
    List<ReadBook> updatedReadBooks,
  ) async {
    final List<ReadBook> existingReadBooks =
        await _loadReadBooksFromDay(userId, date);
    for (final ReadBook readBook in existingReadBooks) {
      final String bookId = readBook.bookId;
      if (updatedReadBooks.doesNotContainBook(bookId)) {
        await _sqliteReadBookService.deleteReadBook(
          userId: userId,
          date: date,
          bookId: bookId,
        );
      }
    }
  }

  Future<List<ReadBook>> _loadReadBooksFromDay(
    String userId,
    String date,
  ) async {
    final List<SqliteReadBook> readBooks =
        await _sqliteReadBookService.loadUserReadBooks(
      userId: userId,
      date: date,
    );
    return _segregateReadBooksIntoDbDays(readBooks).first.readBooks;
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
