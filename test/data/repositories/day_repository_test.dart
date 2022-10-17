import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/repositories/day_repository.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/local_db/mock_day_local_db_service.dart';
import '../../mocks/mock_device.dart';
import '../../mocks/remote_db/mock_day_remote_db_service.dart';
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

      final Stream<List<Day>?> days$ = repository.getUserDays(userId: userId);

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
    'load user days from month, should load user days from month from local db and should assign them to list',
    () async {
      const int month = 9;
      const int year = 2022;
      final List<Day> userDaysFromMonth = [
        createDay(
          userId: userId,
          date: DateTime(year, month, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 120),
            createReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(year, month, 18),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 25),
          ],
        ),
      ];
      final List<Day> expectedUserDaysFromMonth = [
        createDay(
          userId: userId,
          date: DateTime(year, month, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 120),
            createReadBook(bookId: 'b2', readPagesAmount: 50),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(year, month, 18),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 25),
          ],
        ),
      ];
      dayLocalDbService.mockLoadUserDaysFromMonth(
        userDaysFromMonth: userDaysFromMonth,
      );

      await repository.loadUserDaysFromMonth(
        userId: userId,
        month: month,
        year: year,
      );
      final Stream<List<Day>?> userDaysFromMonth$ = repository.getUserDays(
        userId: userId,
      );

      verify(
        () => dayLocalDbService.loadUserDaysFromMonth(
          userId: userId,
          month: month,
          year: year,
        ),
      ).called(1);
      expect(await userDaysFromMonth$.first, expectedUserDaysFromMonth);
    },
  );

  group(
    'add new read pages',
    () {
      final DateTime date = DateTime(2022, 9, 20);
      final String dateInStr = mapDateTimeToString(date);
      const String bookId = 'b1';
      const int amountOfReadPagesToAdd = 40;

      Future<void> callAddNewReadPagesMethod() async {
        await repository.addNewReadPages(
          userId: userId,
          date: date,
          bookId: bookId,
          amountOfReadPagesToAdd: amountOfReadPagesToAdd,
        );
      }

      setUp(() {
        dayRemoteDbService.mockAddNewReadPages();
      });

      test(
        'device has internet connection, day does not exist in list, should call methods responsible for adding new read pages to remote and local db and should add new day to list',
        () async {
          final Day updatedDay = createDay(
            userId: userId,
            date: date,
            readBooks: [
              createReadBook(
                bookId: bookId,
                readPagesAmount: amountOfReadPagesToAdd,
              ),
            ],
          );
          final List<Day> expectedUserDays = [
            createDay(
              userId: userId,
              date: date,
              readBooks: [
                createReadBook(
                  bookId: bookId,
                  readPagesAmount: amountOfReadPagesToAdd,
                ),
              ],
            ),
          ];
          device.mockHasDeviceInternetConnection(value: true);
          dayLocalDbService.mockAddNewReadPages(updatedDay: updatedDay);

          await callAddNewReadPagesMethod();
          final Stream<List<Day>?> userDays$ = repository.getUserDays(
            userId: userId,
          );

          verify(
            () => dayRemoteDbService.addNewReadPages(
              userId: userId,
              date: dateInStr,
              bookId: bookId,
              amountOfReadPagesToAdd: amountOfReadPagesToAdd,
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.addNewReadPages(
              userId: userId,
              date: dateInStr,
              bookId: bookId,
              amountOfReadPagesToAdd: amountOfReadPagesToAdd,
              withModifiedSyncState: false,
            ),
          ).called(1);
          expect(await userDays$.first, expectedUserDays);
        },
      );

      test(
        'device has internet connection, day exists in list, should call methods responsible for adding new read pages to remote and local db and should update day in list',
        () async {
          final Day existingDay = createDay(
            userId: userId,
            date: date,
            readBooks: [
              createReadBook(bookId: bookId, readPagesAmount: 10),
            ],
          );
          final Day updatedDay = createDay(
            userId: userId,
            date: date,
            readBooks: [
              createReadBook(
                bookId: bookId,
                readPagesAmount: 10 + amountOfReadPagesToAdd,
              ),
            ],
          );
          final List<Day> userDays = [existingDay];
          final List<Day> expectedUserDays = [updatedDay];
          device.mockHasDeviceInternetConnection(value: true);
          dayLocalDbService.mockAddNewReadPages(updatedDay: updatedDay);
          repository = createRepository(days: userDays);

          await callAddNewReadPagesMethod();
          final Stream<List<Day>?> userDays$ = repository.getUserDays(
            userId: userId,
          );

          verify(
            () => dayRemoteDbService.addNewReadPages(
              userId: userId,
              date: dateInStr,
              bookId: bookId,
              amountOfReadPagesToAdd: amountOfReadPagesToAdd,
            ),
          ).called(1);
          verify(
            () => dayLocalDbService.addNewReadPages(
              userId: userId,
              date: dateInStr,
              bookId: bookId,
              amountOfReadPagesToAdd: amountOfReadPagesToAdd,
              withModifiedSyncState: false,
            ),
          ).called(1);
          expect(await userDays$.first, expectedUserDays);
        },
      );

      test(
        'device has not internet connection, should only call method responsible for adding new read pages to local db with modified sync state set as true',
        () async {
          final Day updatedDay = createDay(
            userId: userId,
            date: date,
            readBooks: [
              createReadBook(
                bookId: bookId,
                readPagesAmount: amountOfReadPagesToAdd,
              ),
            ],
          );
          device.mockHasDeviceInternetConnection(value: false);
          dayLocalDbService.mockAddNewReadPages(updatedDay: updatedDay);

          await callAddNewReadPagesMethod();

          verifyNever(
            () => dayRemoteDbService.addNewReadPages(
              userId: userId,
              date: dateInStr,
              bookId: bookId,
              amountOfReadPagesToAdd: amountOfReadPagesToAdd,
            ),
          );
          verify(
            () => dayLocalDbService.addNewReadPages(
              userId: userId,
              date: dateInStr,
              bookId: bookId,
              amountOfReadPagesToAdd: amountOfReadPagesToAdd,
              withModifiedSyncState: true,
            ),
          ).called(1);
        },
      );
    },
  );
}
