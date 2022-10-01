import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/day_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/synchronizers/day_synchronizer.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/extensions/list_extensions.dart';
import 'package:app/models/device.dart';
import 'package:rxdart/rxdart.dart';

class DayRepository implements DayInterface {
  late final DaySynchronizer _daySynchronizer;
  late final DayLocalDbService _dayLocalDbService;
  late final DayRemoteDbService _dayRemoteDbService;
  late final Device _device;
  final BehaviorSubject<List<Day>> _days$ = BehaviorSubject();

  DayRepository({
    required DaySynchronizer daySynchronizer,
    required DayLocalDbService dayLocalDbService,
    required DayRemoteDbService dayRemoteDbService,
    required Device device,
    List<Day> days = const [],
  }) {
    _daySynchronizer = daySynchronizer;
    _dayLocalDbService = dayLocalDbService;
    _dayRemoteDbService = dayRemoteDbService;
    _device = device;
    _days$.add(days);
  }

  Stream<List<Day>> get _daysStream$ => _days$.stream;

  @override
  Stream<List<Day>> getUserDays({required String userId}) {
    return _daysStream$.map(
      (List<Day> days) => days
          .where(
            (Day day) => day.userId == userId,
          )
          .toList(),
    );
  }

  @override
  Future<void> initializeForUser({required String userId}) async {
    if (await _device.hasInternetConnection()) {
      await _daySynchronizer.synchronizeUserDaysMarkedAsAdded(userId: userId);
      await _daySynchronizer.synchronizeUserDaysMarkedAsUpdated(userId: userId);
      await _daySynchronizer.synchronizeUserUnmodifiedDays(userId: userId);
    }
  }

  @override
  Future<void> loadUserDays({required String userId}) async {
    final List<DbDay> userDbDays =
        await _dayLocalDbService.loadUserDays(userId: userId);
    final List<Day> userDays =
        userDbDays.map(DayMapper.mapFromDbModelToEntity).toList();
    _addDaysToList(userDays);
  }

  @override
  Future<void> addNewReadPages({
    required String userId,
    required DateTime date,
    required String bookId,
    required int amountOfReadPagesToAdd,
  }) async {
    final String dateInString = DateMapper.mapFromDateTimeToString(date);
    bool shouldModifySyncStateInLocalDb = true;
    if (await _device.hasInternetConnection()) {
      await _dayRemoteDbService.addNewReadPages(
        userId: userId,
        date: dateInString,
        bookId: bookId,
        amountOfReadPagesToAdd: amountOfReadPagesToAdd,
      );
      shouldModifySyncStateInLocalDb = false;
    }
    final DbDay updatedDbDay = await _dayLocalDbService.addNewReadPages(
      userId: userId,
      date: dateInString,
      bookId: bookId,
      amountOfReadPagesToAdd: amountOfReadPagesToAdd,
      withModifiedSyncState: shouldModifySyncStateInLocalDb,
    );
    final Day updatedDay = DayMapper.mapFromDbModelToEntity(updatedDbDay);
    if (_days$.value.containsUserDay(userId: userId, date: date)) {
      _updateDayInList(updatedDay);
    } else {
      _addDaysToList([updatedDay]);
    }
  }

  @override
  void reset() {
    _days$.add([]);
  }

  void _addDaysToList(List<Day> daysToAdd) {
    final List<Day> updatedDays = [..._days$.value];
    updatedDays.addAll(daysToAdd);
    _days$.add(
      updatedDays.removeRepetitions(),
    );
  }

  void _updateDayInList(Day updatedDay) {
    final List<Day> updatedDays = [..._days$.value];
    final int dayIndex = updatedDays.indexOfUserDay(
      userId: updatedDay.userId,
      date: updatedDay.date,
    );
    updatedDays[dayIndex] = updatedDay;
    _days$.add(
      updatedDays.removeRepetitions(),
    );
  }
}

extension _DaysExtensions on List<Day> {
  bool containsUserDay({required String userId, required DateTime date}) {
    final int dayIndex = indexOfUserDay(userId: userId, date: date);
    return dayIndex >= 0;
  }

  int indexOfUserDay({required String userId, required DateTime date}) {
    return indexWhere(
      (Day day) => day.userId == userId && day.date == date,
    );
  }
}
