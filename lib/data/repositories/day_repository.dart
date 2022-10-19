import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/synchronizers/day_synchronizer.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/models/device.dart';
import 'package:app/models/repository.dart';

class DayRepository extends Repository<Day> implements DayInterface {
  late final DaySynchronizer _daySynchronizer;
  late final DayLocalDbService _dayLocalDbService;
  late final DayRemoteDbService _dayRemoteDbService;
  late final Device _device;

  DayRepository({
    required DaySynchronizer daySynchronizer,
    required DayLocalDbService dayLocalDbService,
    required DayRemoteDbService dayRemoteDbService,
    required Device device,
    List<Day>? days,
  }) {
    _daySynchronizer = daySynchronizer;
    _dayLocalDbService = dayLocalDbService;
    _dayRemoteDbService = dayRemoteDbService;
    _device = device;

    if (days != null) {
      addEntities(days);
    }
  }

  @override
  Stream<List<Day>?> getUserDays({required String userId}) {
    return stream.map(
      (List<Day>? days) => days
          ?.where(
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
  Future<void> loadUserDaysFromMonth({
    required String userId,
    required int month,
    required int year,
  }) async {
    final List<Day> userDays = await _dayLocalDbService.loadUserDaysFromMonth(
      userId: userId,
      month: month,
      year: year,
    );
    addEntities(userDays);
  }

  @override
  Future<void> addNewDay({required Day day}) async {
    SyncState syncState = SyncState.added;
    if (await _device.hasInternetConnection()) {
      await _dayRemoteDbService.addDay(day: day);
      syncState = SyncState.none;
    }
    await _dayLocalDbService.addDay(
      day: day,
      syncState: syncState,
    );
    addEntity(day);
  }

  @override
  Future<void> updateDay({required Day updatedDay}) async {
    SyncState syncState = SyncState.updated;
    if (await _device.hasInternetConnection()) {
      await _dayRemoteDbService.updateDay(updatedDay: updatedDay);
      syncState = SyncState.none;
    }
    await _dayLocalDbService.updateDay(
      userId: updatedDay.userId,
      date: updatedDay.date,
      readBooks: updatedDay.readBooks,
      syncState: syncState,
    );
    updateEntity(updatedDay);
  }

  @override
  Future<void> deleteDay({
    required String userId,
    required DateTime date,
  }) async {
    if (await _device.hasInternetConnection()) {
      await _dayRemoteDbService.deleteDay(userId: userId, date: date);
      await _dayLocalDbService.deleteDay(userId: userId, date: date);
    } else {
      await _dayLocalDbService.updateDay(
        userId: userId,
        date: date,
        syncState: SyncState.deleted,
      );
    }
    final String dayId = _getDayId(userId, date);
    removeEntity(dayId);
  }

  String _getDayId(String userId, DateTime date) {
    return Day(userId: userId, date: date, readBooks: const []).id;
  }
}
