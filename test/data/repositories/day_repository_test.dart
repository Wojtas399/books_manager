import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/data/repositories/day_repository.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/db_services/mock_day_local_db_service.dart';
import '../../mocks/db_services/mock_day_remote_db_service.dart';
import '../../mocks/mock_device.dart';
import '../../mocks/synchronizers/mock_day_synchronizer.dart';

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

  String mapDateTimeToString(DateTime dateTime) {
    return DateMapper.mapFromDateTimeToString(dateTime);
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(dayLocalDbService);
    reset(dayRemoteDbService);
    reset(device);
  });

  test(
    'get user days, should return stream which contains days matching to user id',
    () async {
      final List<Day> days = [
        createDay(userId: userId, date: DateTime(2022, 9, 20)),
        createDay(userId: 'u2', date: DateTime(2022, 8, 15)),
        createDay(userId: userId, date: DateTime(2022, 7, 10)),
      ];
      final List<Day> expectedDays = [days.first, days.last];
      repository = createRepository(days: days);

      final Stream<List<Day>> days$ = repository.getUserDays(userId: userId);

      expect(await days$.first, expectedDays);
    },
  );

  group(
    'initialize for user',
    () {
      setUp(() {
        daySynchronizer.mockSynchronizeUserDaysMarkedAsAdded();
        daySynchronizer.mockSynchronizeUserDaysMarkedAsUpdated();
        daySynchronizer.mockSynchronizeUserUnmodifiedDays();
      });

      test(
        'device has internet connection, should call all methods from day synchronizer responsible for synchronizing user days',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await repository.initializeForUser(userId: userId);

          verify(
            () => daySynchronizer.synchronizeUserDaysMarkedAsAdded(
              userId: userId,
            ),
          ).called(1);
          verify(
            () => daySynchronizer.synchronizeUserDaysMarkedAsUpdated(
              userId: userId,
            ),
          ).called(1);
          verify(
            () => daySynchronizer.synchronizeUserUnmodifiedDays(
              userId: userId,
            ),
          ).called(1);
        },
      );

      test(
        'device has not internet connection, should do nothing',
        () async {
          device.mockHasDeviceInternetConnection(value: false);

          await repository.initializeForUser(userId: userId);

          verifyNever(
            () => daySynchronizer.synchronizeUserDaysMarkedAsAdded(
              userId: userId,
            ),
          );
          verifyNever(
            () => daySynchronizer.synchronizeUserDaysMarkedAsUpdated(
              userId: userId,
            ),
          );
          verifyNever(
            () => daySynchronizer.synchronizeUserUnmodifiedDays(
              userId: userId,
            ),
          );
        },
      );
    },
  );

  test(
    'load user days, should load user days from local db and assign them to list',
    () async {
      final List<DbDay> userDbDays = [
        createDbDay(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 120),
            createDbReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDbDay(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 18)),
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 25),
          ],
        ),
      ];
      final List<Day> expectedUserDays = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 120),
            createReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 18),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 25),
          ],
        ),
      ];
      dayLocalDbService.mockLoadUserDays(userDbDays: userDbDays);

      await repository.loadUserDays(userId: userId);
      final Stream<List<Day>> userDays$ = repository.getUserDays(
        userId: userId,
      );

      expect(await userDays$.first, expectedUserDays);
    },
  );

  group(
    'add user read book',
    () {
      final ReadBook readBook = createReadBook(
        bookId: 'b1',
        readPagesAmount: 100,
      );
      final DateTime date = DateTime(2022, 9, 20);
      final DbReadBook dbReadBook = createDbReadBook(
        bookId: readBook.bookId,
        readPagesAmount: readBook.readPagesAmount,
      );

      Future<void> callAddUserReadBookMethod() async {
        await repository.addUserReadBook(
          readBook: readBook,
          userId: userId,
          date: date,
        );
      }

      setUp(() {
        dayRemoteDbService.mockAddUserReadBooks();
      });

      test(
        'device has internet connection, day does not exist in list, should add read book to remote and local db and should add day to list',
        () async {
          final DbDay dbDay = createDbDay(
            userId: userId,
            date: mapDateTimeToString(date),
            readBooks: [
              createDbReadBook(bookId: 'b2', readPagesAmount: 50),
              dbReadBook,
            ],
          );
          final List<Day> userDays = [
            createDay(
              userId: userId,
              date: date,
              readBooks: [
                createReadBook(bookId: 'b2', readPagesAmount: 50),
                readBook,
              ],
            ),
          ];
          device.mockHasDeviceInternetConnection(value: true);
          dayLocalDbService.mockAddUserReadBook(dbDay: dbDay);

          await callAddUserReadBookMethod();
          final Stream<List<Day>> userDays$ =
              repository.getUserDays(userId: userId);

          verify(
            () => dayRemoteDbService.addUserReadBook(
              dbReadBook: dbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.addUserReadBook(
              dbReadBook: dbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
              syncState: SyncState.none,
            ),
          ).called(1);
          expect(await userDays$.first, userDays);
        },
      );

      test(
        'device has internet connection, day exists in list, should add read book to remote and local db and should update proper day in list',
        () async {
          final DbDay dbDay = createDbDay(
            userId: userId,
            date: mapDateTimeToString(date),
            readBooks: [
              createDbReadBook(bookId: 'b2', readPagesAmount: 50),
              dbReadBook,
            ],
          );
          final List<Day> originalUserDays = [
            createDay(
              userId: userId,
              date: DateTime(2022, 9, 23),
              readBooks: [
                createReadBook(bookId: 'b1', readPagesAmount: 40),
              ],
            ),
            createDay(
              userId: userId,
              date: date,
              readBooks: [
                createReadBook(bookId: 'b2', readPagesAmount: 50),
              ],
            ),
          ];
          final List<Day> updatedUserDays = [
            originalUserDays.first,
            originalUserDays.last.copyWith(
              readBooks: [
                originalUserDays.last.readBooks.first,
                readBook,
              ],
            ),
          ];
          device.mockHasDeviceInternetConnection(value: true);
          dayLocalDbService.mockAddUserReadBook(dbDay: dbDay);
          repository = createRepository(days: originalUserDays);

          await callAddUserReadBookMethod();
          final Stream<List<Day>> userDays$ =
              repository.getUserDays(userId: userId);

          verify(
            () => dayRemoteDbService.addUserReadBook(
              dbReadBook: dbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.addUserReadBook(
              dbReadBook: dbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
              syncState: SyncState.none,
            ),
          ).called(1);
          expect(await userDays$.first, updatedUserDays);
        },
      );

      test(
        'device has not internet connection, should add read book to local db with sync state set as added',
        () async {
          final DbDay dbDay = createDbDay(
            userId: userId,
            date: mapDateTimeToString(date),
            readBooks: [dbReadBook],
          );
          device.mockHasDeviceInternetConnection(value: false);
          dayLocalDbService.mockAddUserReadBook(dbDay: dbDay);

          await callAddUserReadBookMethod();

          verifyNever(
            () => dayRemoteDbService.addUserReadBook(
              dbReadBook: dbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
            ),
          );
          verify(
            () => dayLocalDbService.addUserReadBook(
              dbReadBook: dbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
              syncState: SyncState.added,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'update read pages amount of user read book',
    () {
      final DateTime date = DateTime(2022, 9, 20);
      const String bookId = 'b1';
      const int updatedReadPagesAmount = 40;
      final Day originalDay = createDay(
        userId: userId,
        date: date,
        readBooks: [
          createReadBook(bookId: bookId, readPagesAmount: 20),
          createReadBook(bookId: 'b2', readPagesAmount: 100),
        ],
      );
      final Day updatedDay = originalDay.copyWith(
        readBooks: [
          originalDay.readBooks.first.copyWith(
            readPagesAmount: updatedReadPagesAmount,
          ),
          originalDay.readBooks.last,
        ],
      );
      final DbReadBook updatedDbReadBook = createDbReadBook(
        bookId: bookId,
        readPagesAmount: updatedReadPagesAmount,
      );
      final DbDay updatedDbDay = createDbDay(
        userId: userId,
        date: mapDateTimeToString(date),
        readBooks: [
          updatedDbReadBook,
          createDbReadBook(bookId: 'b2', readPagesAmount: 100),
        ],
      );
      final List<Day> originalDays = [originalDay];
      final List<Day> updatedDays = [updatedDay];

      Future<void> callUpdateReadPagesAmountOfUserReadBookMethod() async {
        await repository.updateReadPagesAmountOfUserReadBook(
          userId: userId,
          date: date,
          bookId: bookId,
          updatedReadPagesAmount: updatedReadPagesAmount,
        );
      }

      setUp(() {
        dayRemoteDbService.mockUpdateBookReadPagesAmountInDay();
        dayLocalDbService.mockUpdateReadBook(dbDay: updatedDbDay);
        repository = createRepository(days: originalDays);
      });

      test(
        'device has internet connection, should update read pages in remote and local db and should update proper day in list',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await callUpdateReadPagesAmountOfUserReadBookMethod();
          final Stream<List<Day>> userDays$ =
              repository.getUserDays(userId: userId);

          verify(
            () => dayRemoteDbService.updateBookReadPagesAmountInDay(
              updatedDbReadBook: updatedDbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.updateReadBook(
              userId: userId,
              date: mapDateTimeToString(date),
              bookId: bookId,
              readPagesAmount: updatedReadPagesAmount,
              syncState: SyncState.none,
            ),
          ).called(1);
          expect(await userDays$.first, updatedDays);
        },
      );

      test(
        'device has not internet connection, should update read pages in local db with sync state set as updated and should update proper day in list',
        () async {
          device.mockHasDeviceInternetConnection(value: false);

          await callUpdateReadPagesAmountOfUserReadBookMethod();
          final Stream<List<Day>> userDays$ =
              repository.getUserDays(userId: userId);

          verifyNever(
            () => dayRemoteDbService.updateBookReadPagesAmountInDay(
              updatedDbReadBook: updatedDbReadBook,
              userId: userId,
              date: mapDateTimeToString(date),
            ),
          );
          verify(
            () => dayLocalDbService.updateReadBook(
              userId: userId,
              date: mapDateTimeToString(date),
              bookId: bookId,
              readPagesAmount: updatedReadPagesAmount,
              syncState: SyncState.updated,
            ),
          ).called(1);
          expect(await userDays$.first, updatedDays);
        },
      );
    },
  );

  test(
    'reset, should clean list with days',
    () async {
      final List<Day> userDays = [
        createDay(userId: userId, date: DateTime(2022, 9, 20)),
        createDay(userId: userId, date: DateTime(2022, 9, 18)),
      ];

      repository = createRepository(days: userDays);
      final List<Day> days = await repository.getUserDays(userId: userId).first;
      repository.reset();
      final List<Day> daysAfterCleaning =
          await repository.getUserDays(userId: userId).first;

      expect(days, userDays);
      expect(daysAfterCleaning, []);
    },
  );
}
