import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/synchronizers/day_synchronizer.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/local_db/mock_day_local_db_service.dart';
import '../../mocks/remote_db/mock_day_remote_db_service.dart';

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
        dayLocalDbService.mockAddUserReadBook();
        dayLocalDbService.mockUpdateReadBook();
        dayRemoteDbService.mockAddUserReadBooks();
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
            () => dayLocalDbService.addUserReadBook(
              readBook: remoteDays.first.readBooks.first,
              userId: userId,
              date: '20-09-2022',
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.addUserReadBook(
              readBook: remoteDays.first.readBooks.last,
              userId: userId,
              date: '20-09-2022',
            ),
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
            () => dayRemoteDbService.addUserReadBook(
              readBook: localDays.first.readBooks.first,
              userId: userId,
              date: '20-09-2022',
            ),
          ).called(1);
          verify(
            () => dayRemoteDbService.addUserReadBook(
              readBook: localDays.first.readBooks.last,
              userId: userId,
              date: '20-09-2022',
            ),
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
            () => dayLocalDbService.updateReadBook(
              userId: userId,
              date: '20-09-2022',
              bookId: remoteDays.first.readBooks.first.bookId,
              readPagesAmount: remoteDays.first.readBooks.first.readPagesAmount,
              syncState: SyncState.none,
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.updateReadBook(
              userId: userId,
              date: '20-09-2022',
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
            () => dayLocalDbService.addUserReadBook(
              readBook: any(named: 'readBook'),
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
              readBook: any(named: 'readBook'),
              userId: any(named: 'userId'),
              date: any(named: 'date'),
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
      dayRemoteDbService.mockAddUserReadBooks();
      dayLocalDbService.mockUpdateReadBook();

      await synchronizer.synchronizeUserDaysMarkedAsAdded(userId: userId);

      verify(
        () => dayRemoteDbService.addUserReadBook(
          readBook: daysMarkedAsAdded.first.readBooks.first,
          userId: userId,
          date: '20-09-2022',
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.addUserReadBook(
          readBook: daysMarkedAsAdded.first.readBooks.last,
          userId: userId,
          date: '20-09-2022',
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.addUserReadBook(
          readBook: daysMarkedAsAdded.last.readBooks.first,
          userId: userId,
          date: '18-09-2022',
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateReadBook(
          userId: userId,
          date: '20-09-2022',
          bookId: daysMarkedAsAdded.first.readBooks.first.bookId,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateReadBook(
          userId: userId,
          date: '20-09-2022',
          bookId: daysMarkedAsAdded.first.readBooks.last.bookId,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateReadBook(
          userId: userId,
          date: '18-09-2022',
          bookId: daysMarkedAsAdded.last.readBooks.first.bookId,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user days marked as updated, should load days marked as updated from local db and should update them in remote db',
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
      dayRemoteDbService.mockUpdateBookReadPagesAmountInDay();
      dayLocalDbService.mockUpdateReadBook();

      await synchronizer.synchronizeUserDaysMarkedAsUpdated(userId: userId);

      verify(
        () => dayRemoteDbService.updateBookReadPagesAmountInDay(
          updatedReadBook: daysMarkedAsAdded.first.readBooks.first,
          userId: userId,
          date: '20-09-2022',
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.updateBookReadPagesAmountInDay(
          updatedReadBook: daysMarkedAsAdded.first.readBooks.last,
          userId: userId,
          date: '20-09-2022',
        ),
      ).called(1);
      verify(
        () => dayRemoteDbService.updateBookReadPagesAmountInDay(
          updatedReadBook: daysMarkedAsAdded.last.readBooks.first,
          userId: userId,
          date: '18-09-2022',
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateReadBook(
          userId: userId,
          date: '20-09-2022',
          bookId: daysMarkedAsAdded.first.readBooks.first.bookId,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateReadBook(
          userId: userId,
          date: '20-09-2022',
          bookId: daysMarkedAsAdded.first.readBooks.last.bookId,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => dayLocalDbService.updateReadBook(
          userId: userId,
          date: '18-09-2022',
          bookId: daysMarkedAsAdded.last.readBooks.first.bookId,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );
}
