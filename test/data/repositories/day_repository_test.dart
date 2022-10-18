import 'package:app/data/repositories/day_repository.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
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
}
