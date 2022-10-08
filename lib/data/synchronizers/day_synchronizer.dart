import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
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
    final List<Day> remoteDays = await _dayRemoteDbService.loadUserDays(
      userId: userId,
    );
    final List<Day> localDays = await _dayLocalDbService.loadUserDays(
      userId: userId,
      syncState: SyncState.none,
    );
    await _repairConsistencyOfDays(remoteDays, localDays);
  }

  Future<void> synchronizeUserDaysMarkedAsAdded({
    required String userId,
  }) async {
    final List<Day> daysMarkedAsAdded = await _dayLocalDbService.loadUserDays(
      userId: userId,
      syncState: SyncState.added,
    );
    for (final Day day in daysMarkedAsAdded) {
      await _addReadBooksFromDayToRemoteDb(day);
      await _setSyncStateAsNoneInLocalDbForAllReadBooksFromDay(day);
    }
  }

  Future<void> synchronizeUserDaysMarkedAsUpdated({
    required String userId,
  }) async {
    final List<Day> daysMarkedAsUpdated = await _dayLocalDbService.loadUserDays(
      userId: userId,
      syncState: SyncState.updated,
    );
    for (final Day day in daysMarkedAsUpdated) {
      await _updateReadBooksFromDayInRemoteDb(day);
      await _setSyncStateAsNoneInLocalDbForAllReadBooksFromDay(day);
    }
  }

  Future<void> _repairConsistencyOfDays(
    List<Day> remoteDays,
    List<Day> localDays,
  ) async {
    final List<DateTime> remoteDates = remoteDays.getDates();
    final List<DateTime> localDates = localDays.getDates();
    final List<DateTime> uniqueDates = [
      ...remoteDates,
      ...localDates,
    ].removeRepetitions();
    for (final DateTime date in uniqueDates) {
      final Day? remoteDay = remoteDays.getDayByDate(date);
      final Day? localDay = localDays.getDayByDate(date);
      if (localDay != null && remoteDay != null && remoteDay != localDay) {
        await _updateReadBooksFromDayInLocalDb(remoteDay);
      } else if (remoteDay != null && localDay == null) {
        await _addReadBooksFromDayToLocalDb(remoteDay);
      } else if (remoteDay == null && localDay != null) {
        await _addReadBooksFromDayToRemoteDb(localDay);
      }
    }
  }

  Future<void> _addReadBooksFromDayToRemoteDb(Day day) async {
    for (final ReadBook readBook in day.readBooks) {
      await _dayRemoteDbService.addUserReadBook(
        readBook: readBook,
        userId: day.userId,
        date: DateMapper.mapFromDateTimeToString(day.date),
      );
    }
  }

  Future<void> _addReadBooksFromDayToLocalDb(Day day) async {
    for (final ReadBook readBook in day.readBooks) {
      await _dayLocalDbService.addUserReadBook(
        readBook: readBook,
        userId: day.userId,
        date: DateMapper.mapFromDateTimeToString(day.date),
      );
    }
  }

  Future<void> _updateReadBooksFromDayInRemoteDb(Day day) async {
    for (final ReadBook readBook in day.readBooks) {
      await _dayRemoteDbService.updateBookReadPagesAmountInDay(
        updatedReadBook: readBook,
        userId: day.userId,
        date: DateMapper.mapFromDateTimeToString(day.date),
      );
    }
  }

  Future<void> _updateReadBooksFromDayInLocalDb(Day day) async {
    for (final ReadBook readBook in day.readBooks) {
      await _dayLocalDbService.updateReadBook(
        userId: day.userId,
        date: DateMapper.mapFromDateTimeToString(day.date),
        bookId: readBook.bookId,
        readPagesAmount: readBook.readPagesAmount,
        syncState: SyncState.none,
      );
    }
  }

  Future<void> _setSyncStateAsNoneInLocalDbForAllReadBooksFromDay(
    Day day,
  ) async {
    for (final ReadBook readBook in day.readBooks) {
      await _dayLocalDbService.updateReadBook(
        userId: day.userId,
        date: DateMapper.mapFromDateTimeToString(day.date),
        bookId: readBook.bookId,
        syncState: SyncState.none,
      );
    }
  }
}

extension _DaysExtensions on List<Day> {
  List<DateTime> getDates() {
    return map((Day day) => day.date).toList();
  }

  Day? getDayByDate(DateTime date) {
    final List<Day?> days = [...this];
    return days.firstWhere(
      (Day? day) => day?.date == date,
      orElse: () => null,
    );
  }
}
