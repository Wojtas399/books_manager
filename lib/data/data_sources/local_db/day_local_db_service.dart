import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_pages_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/day_book_mapper.dart';
import 'package:app/data/mappers/day_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_day_book.dart';
import 'package:app/extensions/list_extensions.dart';
import 'package:app/providers/date_provider.dart';

class DayLocalDbService {
  late final SqliteReadPagesService _sqliteReadPagesService;
  late final DateProvider _dateProvider;

  DayLocalDbService({
    required SqliteReadPagesService sqliteReadPagesService,
    required DateProvider dateProvider,
  }) {
    _sqliteReadPagesService = sqliteReadPagesService;
    _dateProvider = dateProvider;
  }

  Future<List<DbDay>> loadUserDays({required String userId}) async {
    final List<SqliteReadPages> listOfReadPages =
        await _loadListOfUserReadPages(userId: userId);
    return _segregateListOfReadPagesIntoDbDays(listOfReadPages);
  }

  Future<DbDay> addReadPagesForUser({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  }) async {
    final String todayDateStr = _getNowAsStr();
    final List<SqliteReadPages> readPagesFromToday =
        await _loadListOfUserReadPages(userId: userId, date: todayDateStr);
    final List<String> booksIds = readPagesFromToday
        .map((SqliteReadPages sqliteReadPages) => sqliteReadPages.bookId)
        .toList();
    if (booksIds.contains(bookId)) {
      final int todayBookReadPagesIndex = readPagesFromToday.indexWhere(
        (SqliteReadPages sqliteReadPages) => sqliteReadPages.bookId == bookId,
      );
      final SqliteReadPages updatedSqliteReadPages = await _updateReadPages(
        sqliteReadPages: readPagesFromToday[todayBookReadPagesIndex],
        readPagesAmountToAdd: readPagesAmount,
      );
      readPagesFromToday[todayBookReadPagesIndex] = updatedSqliteReadPages;
    } else {
      final SqliteReadPages addedSqliteReadPages = await _addNewReadPages(
        userId: userId,
        date: todayDateStr,
        bookId: bookId,
        readPagesAmount: readPagesAmount,
      );
      readPagesFromToday.add(addedSqliteReadPages);
    }
    return DayMapper.mapFromListOfSqliteModelsToDbModel(readPagesFromToday);
  }

  Future<List<SqliteReadPages>> _loadListOfUserReadPages({
    required String userId,
    String? date,
  }) async {
    return await _sqliteReadPagesService.loadListOfUserReadPages(
      userId: userId,
      date: date,
    );
  }

  List<DbDay> _segregateListOfReadPagesIntoDbDays(
    List<SqliteReadPages> listOfReadPages,
  ) {
    final List<DbDay> dbDays = [];
    final List<String> existingDates = [];
    for (final SqliteReadPages readPages in listOfReadPages) {
      if (existingDates.doesNotContain(readPages.date)) {
        existingDates.add(readPages.date);
        final DbDay newDbDay = _createDbDayFromSqliteReadPages(readPages);
        dbDays.add(newDbDay);
      } else {
        final DbDayBook newDbDayBook =
            _createDbDayBookFromSqliteReadPages(readPages);
        final int dayIndex = dbDays.indexWhere(
          (DbDay dbDay) => dbDay.date == readPages.date,
        );
        final DbDay dbDay = dbDays[dayIndex];
        dbDays[dayIndex] = dbDay.copyWith(
          booksWithReadPages: [...dbDay.booksWithReadPages, newDbDayBook],
        );
      }
    }
    return dbDays;
  }

  Future<SqliteReadPages> _updateReadPages({
    required SqliteReadPages sqliteReadPages,
    required int readPagesAmountToAdd,
  }) async {
    final int readPagesAmount = sqliteReadPages.readPagesAmount;
    final int newReadPagesAmount = readPagesAmount + readPagesAmountToAdd;
    final SqliteReadPages updatedReadPages =
        sqliteReadPages.copyWithReadPagesAmount(newReadPagesAmount);
    await _sqliteReadPagesService.updateReadPages(
      updatedReadPages: updatedReadPages,
    );
    return updatedReadPages;
  }

  Future<SqliteReadPages> _addNewReadPages({
    required String userId,
    required String date,
    required String bookId,
    required int readPagesAmount,
  }) async {
    final SqliteReadPages newReadPages = SqliteReadPages(
      userId: userId,
      date: date,
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    await _sqliteReadPagesService.addReadPages(sqliteReadPages: newReadPages);
    return newReadPages;
  }

  String _getNowAsStr() {
    return DateMapper.mapFromDateTimeToString(_dateProvider.getNow());
  }

  DbDay _createDbDayFromSqliteReadPages(SqliteReadPages sqliteReadPages) {
    return DayMapper.mapFromListOfSqliteModelsToDbModel([sqliteReadPages]);
  }

  DbDayBook _createDbDayBookFromSqliteReadPages(
    SqliteReadPages sqliteReadPages,
  ) {
    return DayBookMapper.mapFromSqliteModelToDbModel(sqliteReadPages);
  }
}
