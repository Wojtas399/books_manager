import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/synchronizers/day_synchronizer.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/local_db/mock_day_local_db_service.dart';
import '../../mocks/data/remote_db/mock_day_remote_db_service.dart';

void main() {
  final dayLocalDbService = MockDayLocalDbService();
  final dayRemoteDbService = MockDayRemoteDbService();
  late DaySynchronizer synchronizer;
  const String userId = 'u1';

  setUp(() {
    synchronizer = DaySynchronizer(
      dayLocalDbService: dayLocalDbService,
      dayRemoteDbService: dayRemoteDbService,
    );
  });

  tearDown(() {
    reset(dayLocalDbService);
    reset(dayRemoteDbService);
  });

  group(
    'synchronize user unmodified days',
    () {
      void mockRemoteAndLocalLoadDaysMethods({
        required List<Day> remoteDays,
        required List<Day> localDays,
      }) {
        dayRemoteDbService.mockLoadUserDays(userDays: remoteDays);
        dayLocalDbService.mockLoadUserDays(userDays: localDays);
      }

      Future<void> callSynchronizeUserUnmodifiedDaysMethod() async {
        await synchronizer.synchronizeUserUnmodifiedDays(userId: userId);
      }

      setUp(() {
        dayLocalDbService.mockAddDay();
        dayLocalDbService.mockUpdateDay();
        dayRemoteDbService.mockAddDay();
      });

      test(
        'date does not exist in local db but exists in remote db, should add day with this date to local db',
        () async {
          final List<Day> remoteDays = [
            createDay(
              userId: userId,
              date: DateTime(2022, 9, 20),
              readBooks: [
                createReadBook(bookId: 'b1', readPagesAmount: 100),
                createReadBook(bookId: 'b2', readPagesAmount: 20),
              ],
            ),
          ];
          final List<Day> localDays = [];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verify(
            () => dayLocalDbService.addDay(day: remoteDays.first),
          ).called(1);
        },
      );

      test(
        'date does not exist in remote db but exists in local db, should add day with this date to remote db',
        () async {
          final List<Day> localDays = [
            createDay(
              userId: userId,
              date: DateTime(2022, 9, 20),
              readBooks: [
                createReadBook(bookId: 'b1', readPagesAmount: 100),
                createReadBook(bookId: 'b2', readPagesAmount: 20),
              ],
            ),
          ];
          final List<Day> remoteDays = [];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verify(
            () => dayRemoteDbService.addDay(day: localDays.first),
          ).called(1);
        },
      );

      test(
        'date exists in remote and local db, should update local day with this date to be consistent with remote day if they are different',
        () async {
          final List<Day> remoteDays = [
            createDay(
              userId: userId,
              date: DateTime(2022, 9, 20),
              readBooks: [
                createReadBook(bookId: 'b1', readPagesAmount: 100),
                createReadBook(bookId: 'b2', readPagesAmount: 200),
              ],
            ),
          ];
          final List<Day> localDays = [
            createDay(
              userId: userId,
              date: DateTime(2022, 9, 20),
              readBooks: [
                createReadBook(bookId: 'b1', readPagesAmount: 10),
                createReadBook(bookId: 'b2', readPagesAmount: 20),
              ],
            ),
          ];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verify(
            () => dayLocalDbService.updateDay(
              userId: userId,
              date: remoteDays.first.date,
              readBooks: remoteDays.first.readBooks,
            ),
          ).called(1);
        },
      );

      test(
        'date exists in remote and local db, should do nothing if days are the same',
        () async {
          final Day day = createDay(
            userId: userId,
            date: DateTime(2022, 9, 20),
            readBooks: [
              createReadBook(bookId: 'b1', readPagesAmount: 100),
              createReadBook(bookId: 'b2', readPagesAmount: 200),
            ],
          );
          final List<Day> remoteDays = [day];
          final List<Day> localDays = [day];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verifyNever(
            () => dayLocalDbService.addDay(
              day: any(named: 'day'),
            ),
          );
          verifyNever(
            () => dayLocalDbService.updateDay(
              userId: userId,
              date: any(named: 'date'),
            ),
          );
          verifyNever(
            () => dayRemoteDbService.addDay(
              day: any(named: 'day'),
            ),
          );
        },
      );
    },
  );

  test(
    'synchronize user days marked as added, should load days marked as added from local db, should add them to remote db and should set their sync state as none in local db',
    () async {
      final List<Day> daysMarkedAsAdded = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 100),
            createReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 18),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 200),
          ],
        ),
      ];
      dayLocalDbService.mockLoadUserDays(userDays: daysMarkedAsAdded);
      dayRemoteDbService.mockAddDay();
      dayLocalDbService.mockUpdateDay();

      await synchronizer.synchronizeUserDaysMarkedAsAdded(userId: userId);

      verify(
        () => dayRemoteDbService.addDay(day: daysMarkedAsAdded.first),
      ).called(1);
      verify(
        () => dayRemoteDbService.addDay(day: daysMarkedAsAdded.last),
      ).called(1);
      verify(
        () => dayLocalDbService.updateDay(
          userId: userId,
          date: daysMarkedAsAdded.first.date,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateDay(
          userId: userId,
          date: daysMarkedAsAdded.last.date,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user days marked as updated, should load days marked as updated from local db, should update them in remote db and should set their sync state as none in local db',
    () async {
      final List<Day> daysMarkedAsUpdated = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 100),
            createReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 18),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 200),
          ],
        ),
      ];
      dayLocalDbService.mockLoadUserDays(userDays: daysMarkedAsUpdated);
      dayRemoteDbService.mockUpdateDay();
      dayLocalDbService.mockUpdateDay();

      await synchronizer.synchronizeUserDaysMarkedAsUpdated(userId: userId);

      verify(
        () => dayRemoteDbService.updateDay(
          updatedDay: daysMarkedAsUpdated.first,
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.updateDay(
          updatedDay: daysMarkedAsUpdated.last,
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateDay(
          userId: userId,
          date: daysMarkedAsUpdated.first.date,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateDay(
          userId: userId,
          date: daysMarkedAsUpdated.last.date,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );
}
