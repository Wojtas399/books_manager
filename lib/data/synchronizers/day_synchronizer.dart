import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/extensions/list_extensions.dart';

class DaySynchronizer {
  late final DayLocalDbService _dayLocalDbService;
  late final DayRemoteDbService _dayRemoteDbService;

  DaySynchronizer({
    required DayLocalDbService dayLocalDbService,
    required DayRemoteDbService dayRemoteDbService,
  }) {
    _dayLocalDbService = dayLocalDbService;
    _dayRemoteDbService = dayRemoteDbService;
  }

  Future<void> synchronizeUserUnmodifiedDays({required String userId}) async {
    final List<DbDay> remoteDays = await _dayRemoteDbService.loadUserDays(
      userId: userId,
    );
    final List<DbDay> localDays = await _dayLocalDbService.loadUserDays(
      userId: userId,
      syncState: SyncState.none,
    );
    await _repairConsistencyOfDays(remoteDays, localDays);
  }

  Future<void> synchronizeUserDaysMarkedAsAdded({
    required String userId,
  }) async {
    final List<DbDay> dbDaysMarkedAsAdded = await _dayLocalDbService
        .loadUserDays(userId: userId, syncState: SyncState.added);
    for (final DbDay dbDay in dbDaysMarkedAsAdded) {
      await _addReadBooksFromDayToRemoteDb(dbDay);
    }
  }

  Future<void> synchronizeUserDaysMarkedAsUpdated({
    required String userId,
  }) async {
    final List<DbDay> dbDaysMarkedAsUpdated = await _dayLocalDbService
        .loadUserDays(userId: userId, syncState: SyncState.updated);
    for (final DbDay dbDay in dbDaysMarkedAsUpdated) {
      await _updateReadBooksFromDayInRemoteDb(dbDay);
    }
  }

  Future<void> _repairConsistencyOfDays(
    List<DbDay> remoteDays,
    List<DbDay> localDays,
  ) async {
    final List<String> remoteDates = remoteDays.getOnlyDates();
    final List<String> localDates = localDays.getOnlyDates();
    final List<String> uniqueDates = [
      ...remoteDates,
      ...localDates,
    ].removeRepetitions();
    for (final String date in uniqueDates) {
      final DbDay? remoteDay = remoteDays.getDayByDate(date);
      final DbDay? localDay = localDays.getDayByDate(date);
      if (localDay != null && remoteDay != null && remoteDay != localDay) {
        await _updateReadBooksFromDayInLocalDb(remoteDay);
      } else if (remoteDay != null && localDay == null) {
        await _addReadBooksFromDayToLocalDb(remoteDay);
      } else if (remoteDay == null && localDay != null) {
        await _addReadBooksFromDayToRemoteDb(localDay);
      }
    }
  }

  Future<void> _addReadBooksFromDayToRemoteDb(DbDay dbDay) async {
    for (final DbReadBook dbReadBook in dbDay.readBooks) {
      await _dayRemoteDbService.addUserReadBook(
        dbReadBook: dbReadBook,
        userId: dbDay.userId,
        date: dbDay.date,
      );
    }
  }

  Future<void> _addReadBooksFromDayToLocalDb(DbDay dbDay) async {
    for (final DbReadBook dbReadBook in dbDay.readBooks) {
      await _dayLocalDbService.addUserReadBook(
        dbReadBook: dbReadBook,
        userId: dbDay.userId,
        date: dbDay.date,
      );
    }
  }

  Future<void> _updateReadBooksFromDayInRemoteDb(DbDay dbDay) async {
    for (final DbReadBook dbReadBook in dbDay.readBooks) {
      await _dayRemoteDbService.updateBookReadPagesAmountInDay(
        updatedDbReadBook: dbReadBook,
        userId: dbDay.userId,
        date: dbDay.date,
      );
    }
  }

  Future<void> _updateReadBooksFromDayInLocalDb(DbDay dbDay) async {
    for (final DbReadBook dbReadBook in dbDay.readBooks) {
      await _dayLocalDbService.updateReadBook(
        userId: dbDay.userId,
        date: dbDay.date,
        bookId: dbReadBook.bookId,
        readPagesAmount: dbReadBook.readPagesAmount,
        syncState: SyncState.none,
      );
    }
  }
}

extension _DbDaysExtensions on List<DbDay> {
  List<String> getOnlyDates() {
    return map((DbDay dbDay) => dbDay.date).toList();
  }

  DbDay? getDayByDate(String date) {
    final List<DbDay?> dbDays = [...this];
    return dbDays.firstWhere(
      (DbDay? dbDay) => dbDay?.date == date,
      orElse: () => null,
    );
  }
}
