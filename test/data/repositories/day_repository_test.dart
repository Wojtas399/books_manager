import 'package:app/data/repositories/day_repository.dart';
import 'package:app/domain/entities/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/local_db/mock_day_local_db_service.dart';
import '../../mocks/data/remote_db/mock_day_remote_db_service.dart';
import '../../mocks/data/synchronizers/mock_day_synchronizer.dart';
import '../../mocks/mock_device.dart';

void main() {
  final daySynchronizer = MockDaySynchronizer();
  final dayLocalDbService = MockDayLocalDbService();
  final dayRemoteDbService = MockDayRemoteDbService();
  final device = MockDevice();
  late DayRepository repository;
  const String userId = 'u1';

  DayRepository createRepository({
    List<Day> days = const [],
  }) {
    return DayRepository(
      daySynchronizer: daySynchronizer,
      dayLocalDbService: dayLocalDbService,
      dayRemoteDbService: dayRemoteDbService,
      device: device,
      days: days,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(dayLocalDbService);
    reset(dayRemoteDbService);
    reset(device);
  });

  // test(
  //   'get user days, should return stream which contains days matching to user id',
  //   () async {
  //     final List<Day> days = [
  //       createDay(userId: userId, date: DateTime(2022, 9, 20)),
  //       createDay(userId: 'u2', date: DateTime(2022, 8, 15)),
  //       createDay(userId: userId, date: DateTime(2022, 7, 10)),
  //     ];
  //     final List<Day> expectedDays = [days.first, days.last];
  //     repository = createRepository(days: days);
  //
  //     final Stream<List<Day>?> days$ = repository.getUserDays(userId: userId);
  //
  //     expect(await days$.first, expectedDays);
  //   },
  // );
  //
  // group(
  //   'initialize for user',
  //   () {
  //     setUp(() {
  //       daySynchronizer.mockSynchronizeUserDaysMarkedAsAdded();
  //       daySynchronizer.mockSynchronizeUserDaysMarkedAsUpdated();
  //       daySynchronizer.mockSynchronizeUserUnmodifiedDays();
  //     });
  //
  //     test(
  //       'device has internet connection, should call all methods from day synchronizer responsible for synchronizing user days',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: true);
  //
  //         await repository.initializeForUser(userId: userId);
  //
  //         verify(
  //           () => daySynchronizer.synchronizeUserDaysMarkedAsAdded(
  //             userId: userId,
  //           ),
  //         ).called(1);
  //         verify(
  //           () => daySynchronizer.synchronizeUserDaysMarkedAsUpdated(
  //             userId: userId,
  //           ),
  //         ).called(1);
  //         verify(
  //           () => daySynchronizer.synchronizeUserUnmodifiedDays(
  //             userId: userId,
  //           ),
  //         ).called(1);
  //       },
  //     );
  //
  //     test(
  //       'device has not internet connection, should do nothing',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: false);
  //
  //         await repository.initializeForUser(userId: userId);
  //
  //         verifyNever(
  //           () => daySynchronizer.synchronizeUserDaysMarkedAsAdded(
  //             userId: userId,
  //           ),
  //         );
  //         verifyNever(
  //           () => daySynchronizer.synchronizeUserDaysMarkedAsUpdated(
  //             userId: userId,
  //           ),
  //         );
  //         verifyNever(
  //           () => daySynchronizer.synchronizeUserUnmodifiedDays(
  //             userId: userId,
  //           ),
  //         );
  //       },
  //     );
  //   },
  // );
  //
  // test(
  //   'load user days from month, should load user days from month from local db and should assign them to list',
  //   () async {
  //     const int month = 9;
  //     const int year = 2022;
  //     final List<Day> userDaysFromMonth = [
  //       createDay(
  //         userId: userId,
  //         date: DateTime(year, month, 20),
  //         readBooks: [
  //           createReadBook(bookId: 'b1', readPagesAmount: 120),
  //           createReadBook(bookId: 'b2', readPagesAmount: 50),
  //         ],
  //       ),
  //       createDay(
  //         userId: userId,
  //         date: DateTime(year, month, 18),
  //         readBooks: [
  //           createReadBook(bookId: 'b1', readPagesAmount: 25),
  //         ],
  //       ),
  //     ];
  //     final List<Day> expectedUserDaysFromMonth = [
  //       createDay(
  //         userId: userId,
  //         date: DateTime(year, month, 20),
  //         readBooks: [
  //           createReadBook(bookId: 'b1', readPagesAmount: 120),
  //           createReadBook(bookId: 'b2', readPagesAmount: 50),
  //         ],
  //       ),
  //       createDay(
  //         userId: userId,
  //         date: DateTime(year, month, 18),
  //         readBooks: [
  //           createReadBook(bookId: 'b1', readPagesAmount: 25),
  //         ],
  //       ),
  //     ];
  //     dayLocalDbService.mockLoadUserDaysFromMonth(
  //       userDaysFromMonth: userDaysFromMonth,
  //     );
  //
  //     await repository.loadUserDaysFromMonth(
  //       userId: userId,
  //       month: month,
  //       year: year,
  //     );
  //     final Stream<List<Day>?> userDaysFromMonth$ = repository.getUserDays(
  //       userId: userId,
  //     );
  //
  //     verify(
  //       () => dayLocalDbService.loadUserDaysFromMonth(
  //         userId: userId,
  //         month: month,
  //         year: year,
  //       ),
  //     ).called(1);
  //     expect(await userDaysFromMonth$.first, expectedUserDaysFromMonth);
  //   },
  // );
  //
  // group(
  //   'add new day',
  //   () {
  //     const String userId = 'u1';
  //     final Day day = createDay(
  //       date: DateTime(2022, 10, 20),
  //       userId: userId,
  //       readBooks: [
  //         createReadBook(bookId: 'b1', readPagesAmount: 100),
  //         createReadBook(bookId: 'b2', readPagesAmount: 30),
  //       ],
  //     );
  //     final List<Day> existingDays = [
  //       createDay(
  //         date: DateTime(2022, 10, 15),
  //         userId: userId,
  //         readBooks: [
  //           createReadBook(bookId: 'b1', readPagesAmount: 50),
  //         ],
  //       ),
  //       createDay(
  //         date: DateTime(2022, 10, 17),
  //         userId: userId,
  //         readBooks: [
  //           createReadBook(bookId: 'b2', readPagesAmount: 50),
  //         ],
  //       ),
  //     ];
  //     final List<Day> expectedUpdatedDays = [...existingDays, day];
  //
  //     setUp(() {
  //       dayRemoteDbService.mockAddDay();
  //       dayLocalDbService.mockAddDay();
  //       repository = createRepository(days: existingDays);
  //     });
  //
  //     test(
  //       'device has internet connection, should add day to remote and local dbs and should add day to list',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: true);
  //
  //         await repository.addNewDay(day: day);
  //         final Stream<List<Day>?> userDays$ = repository.getUserDays(
  //           userId: userId,
  //         );
  //
  //         verify(
  //           () => dayRemoteDbService.addDay(day: day),
  //         ).called(1);
  //         verify(
  //           () => dayLocalDbService.addDay(
  //             day: day,
  //             syncState: SyncState.none,
  //           ),
  //         ).called(1);
  //         expect(await userDays$.first, expectedUpdatedDays);
  //       },
  //     );
  //
  //     test(
  //       'device does not have internet connection, should add day to local db with sync state set as added and should add day to list',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: false);
  //
  //         await repository.addNewDay(day: day);
  //         final Stream<List<Day>?> userDays$ = repository.getUserDays(
  //           userId: userId,
  //         );
  //
  //         verifyNever(
  //           () => dayRemoteDbService.addDay(day: day),
  //         );
  //         verify(
  //           () => dayLocalDbService.addDay(
  //             day: day,
  //             syncState: SyncState.added,
  //           ),
  //         ).called(1);
  //         expect(await userDays$.first, expectedUpdatedDays);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'update day',
  //   () {
  //     final Day originalDay = createDay(
  //       date: DateTime(2022, 10, 20),
  //       userId: 'u1',
  //       readBooks: [
  //         createReadBook(bookId: 'b1', readPagesAmount: 100),
  //       ],
  //     );
  //     final Day updatedDay = originalDay.copyWith(
  //       readBooks: [
  //         originalDay.readBooks.first.copyWith(readPagesAmount: 200),
  //       ],
  //     );
  //     final List<Day> existingDays = [originalDay];
  //     final List<Day> expectedUpdatedDays = [updatedDay];
  //
  //     setUp(() {
  //       dayRemoteDbService.mockUpdateDay();
  //       dayLocalDbService.mockUpdateDay();
  //       repository = createRepository(days: existingDays);
  //     });
  //
  //     test(
  //       'device has internet connection, should update day in remote and local dbs and should update day in list',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: true);
  //
  //         await repository.updateDay(updatedDay: updatedDay);
  //         final Stream<List<Day>?> userDays$ = repository.getUserDays(
  //           userId: userId,
  //         );
  //
  //         verify(
  //           () => dayRemoteDbService.updateDay(updatedDay: updatedDay),
  //         ).called(1);
  //         verify(
  //           () => dayLocalDbService.updateDay(
  //             userId: userId,
  //             date: updatedDay.date,
  //             readBooks: updatedDay.readBooks,
  //             syncState: SyncState.none,
  //           ),
  //         ).called(1);
  //         expect(await userDays$.first, expectedUpdatedDays);
  //       },
  //     );
  //
  //     test(
  //       'device has not internet connection, should update day in local db with sync state set as updated and should update day in list',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: false);
  //
  //         await repository.updateDay(updatedDay: updatedDay);
  //         final Stream<List<Day>?> userDays$ = repository.getUserDays(
  //           userId: userId,
  //         );
  //
  //         verifyNever(
  //           () => dayRemoteDbService.updateDay(updatedDay: updatedDay),
  //         );
  //         verify(
  //           () => dayLocalDbService.updateDay(
  //             userId: userId,
  //             date: updatedDay.date,
  //             readBooks: updatedDay.readBooks,
  //             syncState: SyncState.updated,
  //           ),
  //         ).called(1);
  //         expect(await userDays$.first, expectedUpdatedDays);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'delete day',
  //   () {
  //     const String userId = 'u1';
  //     final DateTime date = DateTime(2022, 10, 15);
  //     final List<Day> existingDays = [
  //       createDay(
  //         date: date,
  //         userId: userId,
  //       ),
  //       createDay(
  //         date: DateTime(2022, 10, 18),
  //         userId: userId,
  //       ),
  //     ];
  //     final List<Day> expectedUpdatedDays = [existingDays.last];
  //
  //     setUp(() {
  //       repository = createRepository(days: existingDays);
  //     });
  //
  //     test(
  //       'device has internet connection, should delete day from remote and local dbs and should delete day from list',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: true);
  //         dayRemoteDbService.mockDeleteDay();
  //         dayLocalDbService.mockDeleteDay();
  //
  //         await repository.deleteDay(userId: userId, date: date);
  //         final Stream<List<Day>?> userDays$ = repository.getUserDays(
  //           userId: userId,
  //         );
  //
  //         verify(
  //           () => dayRemoteDbService.deleteDay(
  //             userId: userId,
  //             date: date,
  //           ),
  //         ).called(1);
  //         verify(
  //           () => dayLocalDbService.deleteDay(
  //             userId: userId,
  //             date: date,
  //           ),
  //         ).called(1);
  //         expect(await userDays$.first, expectedUpdatedDays);
  //       },
  //     );
  //
  //     test(
  //       'device has not internet connection, should update day in local db with sync state set as deleted and should delete day from list',
  //       () async {
  //         device.mockHasDeviceInternetConnection(value: false);
  //         dayLocalDbService.mockUpdateDay();
  //
  //         await repository.deleteDay(userId: userId, date: date);
  //         final Stream<List<Day>?> userDays$ = repository.getUserDays(
  //           userId: userId,
  //         );
  //
  //         verify(
  //           () => dayLocalDbService.updateDay(
  //             userId: userId,
  //             date: date,
  //             syncState: SyncState.deleted,
  //           ),
  //         ).called(1);
  //         expect(await userDays$.first, expectedUpdatedDays);
  //       },
  //     );
  //   },
  // );
}
