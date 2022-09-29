import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/data/synchronizers/day_synchronizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/db_services/mock_day_local_db_service.dart';
import '../../mocks/db_services/mock_day_remote_db_service.dart';

class FakeDbReadBook extends Fake implements DbReadBook {}

void main() {
  final dayLocalDbService = MockDayLocalDbService();
  final dayRemoteDbService = MockDayRemoteDbService();
  late DaySynchronizer synchronizer;
  const String userId = 'u1';

  setUpAll(() {
    registerFallbackValue(FakeDbReadBook());
    registerFallbackValue(SyncState.none);
  });

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
        required List<DbDay> remoteDays,
        required List<DbDay> localDays,
      }) {
        dayRemoteDbService.mockLoadUserDays(userDbDays: remoteDays);
        dayLocalDbService.mockLoadUserDays(userDbDays: localDays);
      }

      Future<void> callSynchronizeUserUnmodifiedDaysMethod() async {
        await synchronizer.synchronizeUserUnmodifiedDays(userId: userId);
      }

      setUp(() {
        dayLocalDbService.mockAddUserReadBook(dbDay: createDbDay());
        dayLocalDbService.mockUpdateReadBook(dbDay: createDbDay());
        dayRemoteDbService.mockAddUserReadBooks();
      });

      test(
        'date does not exist in local db but exists in remote db, should add day with this date to local db',
        () async {
          final List<DbDay> remoteDays = [
            createDbDay(
              userId: userId,
              date: '20-09-2022',
              readBooks: [
                createDbReadBook(bookId: 'b1', readPagesAmount: 100),
                createDbReadBook(bookId: 'b2', readPagesAmount: 20),
              ],
            ),
          ];
          final List<DbDay> localDays = [];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verify(
            () => dayLocalDbService.addUserReadBook(
              dbReadBook: remoteDays.first.readBooks.first,
              userId: userId,
              date: remoteDays.first.date,
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.addUserReadBook(
              dbReadBook: remoteDays.first.readBooks.last,
              userId: userId,
              date: remoteDays.first.date,
            ),
          ).called(1);
        },
      );

      test(
        'date does not exist in remote db but exists in local db, should add day with this date to remote db',
        () async {
          final List<DbDay> localDays = [
            createDbDay(
              userId: userId,
              date: '20-09-2022',
              readBooks: [
                createDbReadBook(bookId: 'b1', readPagesAmount: 100),
                createDbReadBook(bookId: 'b2', readPagesAmount: 20),
              ],
            ),
          ];
          final List<DbDay> remoteDays = [];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verify(
            () => dayRemoteDbService.addUserReadBook(
              dbReadBook: localDays.first.readBooks.first,
              userId: userId,
              date: localDays.first.date,
            ),
          ).called(1);
          verify(
            () => dayRemoteDbService.addUserReadBook(
              dbReadBook: localDays.first.readBooks.last,
              userId: userId,
              date: localDays.first.date,
            ),
          ).called(1);
        },
      );

      test(
        'date exists in remote and local db, should update local day with this date to be consistent with remote day if they are different',
        () async {
          final List<DbDay> remoteDays = [
            createDbDay(
              userId: userId,
              date: '20-09-2022',
              readBooks: [
                createDbReadBook(bookId: 'b1', readPagesAmount: 100),
                createDbReadBook(bookId: 'b2', readPagesAmount: 200),
              ],
            ),
          ];
          final List<DbDay> localDays = [
            createDbDay(
              userId: userId,
              date: '20-09-2022',
              readBooks: [
                createDbReadBook(bookId: 'b1', readPagesAmount: 10),
                createDbReadBook(bookId: 'b2', readPagesAmount: 20),
              ],
            ),
          ];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verify(
            () => dayLocalDbService.updateReadBook(
              userId: userId,
              date: remoteDays.first.date,
              bookId: remoteDays.first.readBooks.first.bookId,
              readPagesAmount: remoteDays.first.readBooks.first.readPagesAmount,
              syncState: SyncState.none,
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.updateReadBook(
              userId: userId,
              date: remoteDays.first.date,
              bookId: remoteDays.last.readBooks.last.bookId,
              readPagesAmount: remoteDays.last.readBooks.last.readPagesAmount,
              syncState: SyncState.none,
            ),
          ).called(1);
        },
      );

      test(
        'date exists in remote and local db, should do nothing if days are the same',
        () async {
          final DbDay day = createDbDay(
            userId: userId,
            date: '20-09-2022',
            readBooks: [
              createDbReadBook(bookId: 'b1', readPagesAmount: 100),
              createDbReadBook(bookId: 'b2', readPagesAmount: 200),
            ],
          );
          final List<DbDay> remoteDays = [day];
          final List<DbDay> localDays = [day];
          mockRemoteAndLocalLoadDaysMethods(
            remoteDays: remoteDays,
            localDays: localDays,
          );

          await callSynchronizeUserUnmodifiedDaysMethod();

          verifyNever(
            () => dayLocalDbService.addUserReadBook(
              dbReadBook: any(named: 'dbReadBook'),
              userId: any(named: 'userId'),
              date: any(named: 'date'),
            ),
          );
          verifyNever(
            () => dayLocalDbService.updateReadBook(
              userId: any(named: 'userId'),
              date: any(named: 'date'),
              bookId: any(named: 'bookId'),
              readPagesAmount: any(named: 'readPagesAmount'),
              syncState: any(named: 'syncState'),
            ),
          );
          verifyNever(
            () => dayRemoteDbService.addUserReadBook(
              dbReadBook: any(named: 'dbReadBook'),
              userId: any(named: 'userId'),
              date: any(named: 'date'),
            ),
          );
        },
      );
    },
  );

  test(
    'synchronize user days marked as added, should load days marked as added from local db and should add them to remote db',
    () async {
      final List<DbDay> dbDaysMarkedAsAdded = [
        createDbDay(
          userId: userId,
          date: '20-09-2022',
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 100),
            createDbReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDbDay(
          userId: userId,
          date: '18-09-2022',
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 200),
          ],
        ),
      ];
      dayLocalDbService.mockLoadUserDays(userDbDays: dbDaysMarkedAsAdded);
      dayRemoteDbService.mockAddUserReadBooks();

      await synchronizer.synchronizeUserDaysMarkedAsAdded(userId: userId);

      verify(
        () => dayRemoteDbService.addUserReadBook(
          dbReadBook: dbDaysMarkedAsAdded.first.readBooks.first,
          userId: userId,
          date: dbDaysMarkedAsAdded.first.date,
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.addUserReadBook(
          dbReadBook: dbDaysMarkedAsAdded.first.readBooks.last,
          userId: userId,
          date: dbDaysMarkedAsAdded.first.date,
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.addUserReadBook(
          dbReadBook: dbDaysMarkedAsAdded.last.readBooks.first,
          userId: userId,
          date: dbDaysMarkedAsAdded.last.date,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user days marked as updated, should load days marked as updated from local db and should update them in remote db',
    () async {
      final List<DbDay> dbDaysMarkedAsAdded = [
        createDbDay(
          userId: userId,
          date: '20-09-2022',
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 100),
            createDbReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDbDay(
          userId: userId,
          date: '18-09-2022',
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 200),
          ],
        ),
      ];
      dayLocalDbService.mockLoadUserDays(userDbDays: dbDaysMarkedAsAdded);
      dayRemoteDbService.mockUpdateBookReadPagesAmountInDay();

      await synchronizer.synchronizeUserDaysMarkedAsUpdated(userId: userId);

      verify(
        () => dayRemoteDbService.updateBookReadPagesAmountInDay(
          updatedDbReadBook: dbDaysMarkedAsAdded.first.readBooks.first,
          userId: userId,
          date: dbDaysMarkedAsAdded.first.date,
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.updateBookReadPagesAmountInDay(
          updatedDbReadBook: dbDaysMarkedAsAdded.first.readBooks.last,
          userId: userId,
          date: dbDaysMarkedAsAdded.first.date,
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.updateBookReadPagesAmountInDay(
          updatedDbReadBook: dbDaysMarkedAsAdded.last.readBooks.first,
          userId: userId,
          date: dbDaysMarkedAsAdded.last.date,
        ),
      ).called(1);
    },
  );
}
