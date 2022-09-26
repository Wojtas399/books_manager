import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_day_book.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/providers/mock_date_provider.dart';
import '../../../mocks/sqlite/mock_sqlite_read_pages_service.dart';

void main() {
  final sqliteReadPagesService = MockSqliteReadPagesService();
  final dateProvider = MockDateProvider();
  late DayLocalDbService service;

  String mapDateTimeToString(DateTime dateTime) {
    return DateMapper.mapFromDateTimeToString(dateTime);
  }

  setUp(() {
    service = DayLocalDbService(
      sqliteReadPagesService: sqliteReadPagesService,
      dateProvider: dateProvider,
    );
  });

  tearDown(() {
    reset(sqliteReadPagesService);
    reset(dateProvider);
  });

  test(
    'load user days, should load all read pages belonging to user and should segregate them to list of db days',
    () async {
      const String userId = 'userId';
      final List<SqliteReadPages> listOfSqliteReadPages = [
        createSqliteReadPages(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 23)),
          bookId: 'b1',
          readPagesAmount: 20,
        ),
        createSqliteReadPages(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
          bookId: 'b1',
          readPagesAmount: 50,
        ),
        createSqliteReadPages(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
          bookId: 'b2',
          readPagesAmount: 100,
        ),
        createSqliteReadPages(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 18)),
          bookId: 'b2',
          readPagesAmount: 100,
        ),
        createSqliteReadPages(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 23)),
          bookId: 'b2',
          readPagesAmount: 10,
        ),
      ];
      final List<DbDay> expectedDbDays = [
        createDbDay(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 23)),
          booksWithReadPages: [
            createDbDayBook(bookId: 'b1', readPagesAmount: 20),
            createDbDayBook(bookId: 'b2', readPagesAmount: 10),
          ],
        ),
        createDbDay(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
          booksWithReadPages: [
            createDbDayBook(bookId: 'b1', readPagesAmount: 50),
            createDbDayBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
        createDbDay(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 18)),
          booksWithReadPages: [
            createDbDayBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
      ];
      sqliteReadPagesService.mockLoadListOfReadPagesByUserId(
        listOfSqliteReadPages: listOfSqliteReadPages,
      );

      final List<DbDay> dbDays = await service.loadUserDays(userId: userId);

      expect(dbDays, expectedDbDays);
    },
  );

  group(
    'add read pages for user',
    () {
      const String userId = 'u1';
      const String bookId = 'b1';
      const int readPagesAmount = 20;
      final DateTime todayDate = DateTime(2022, 9, 23);
      final String todayDateStr = mapDateTimeToString(todayDate);

      test(
        'read pages for given book and today date does not exist in sqlite db, should add new read pages',
        () async {
          final SqliteReadPages newReadPages = SqliteReadPages(
            userId: userId,
            date: todayDateStr,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: todayDateStr,
            booksWithReadPages: [
              createDbDayBook(bookId: bookId, readPagesAmount: readPagesAmount),
            ],
          );
          dateProvider.mockGetNow(nowDateTime: todayDate);
          sqliteReadPagesService.mockLoadReadPages();
          sqliteReadPagesService.mockAddReadPages();

          final DbDay dbDay = await service.addReadPagesForUser(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => sqliteReadPagesService.addReadPages(
              sqliteReadPages: newReadPages,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );

      test(
        'read pages for given book and today date exists in sqlite db, should update read pages',
        () async {
          final SqliteReadPages readPages = SqliteReadPages(
            userId: userId,
            date: todayDateStr,
            bookId: bookId,
            readPagesAmount: 100,
          );
          final int newAmount = readPages.readPagesAmount + readPagesAmount;
          final SqliteReadPages updatedReadPages =
              readPages.copyWithReadPagesAmount(newAmount);
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: todayDateStr,
            booksWithReadPages: [
              createDbDayBook(bookId: bookId, readPagesAmount: newAmount),
            ],
          );
          dateProvider.mockGetNow(nowDateTime: todayDate);
          sqliteReadPagesService.mockLoadReadPages(sqliteReadPages: readPages);
          sqliteReadPagesService.mockUpdateReadPages();

          final DbDay dbDay = await service.addReadPagesForUser(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => sqliteReadPagesService.updateReadPages(
              updatedReadPages: updatedReadPages,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );
    },
  );
}
