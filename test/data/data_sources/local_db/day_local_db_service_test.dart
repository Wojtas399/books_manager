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
      sqliteReadPagesService.mockLoadListOfUserReadPages(
        listOfUserReadPages: listOfSqliteReadPages,
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

      setUp(() {
        dateProvider.mockGetNow(nowDateTime: todayDate);
      });

      test(
        'book has not been read today, should add new read pages and should return db day with all read books',
        () async {
          final SqliteReadPages readPagesToAdd = createSqliteReadPages(
            userId: userId,
            bookId: bookId,
            date: todayDateStr,
            readPagesAmount: readPagesAmount,
          );
          final List<SqliteReadPages> userReadPagesFromToday = [
            createSqliteReadPages(
              userId: userId,
              bookId: 'b2',
              date: todayDateStr,
              readPagesAmount: 100,
            ),
            createSqliteReadPages(
              userId: userId,
              bookId: 'b3',
              date: todayDateStr,
              readPagesAmount: 40,
            ),
          ];
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: todayDateStr,
            booksWithReadPages: [
              createDbDayBook(bookId: 'b2', readPagesAmount: 100),
              createDbDayBook(bookId: 'b3', readPagesAmount: 40),
              createDbDayBook(bookId: bookId, readPagesAmount: readPagesAmount),
            ],
          );
          sqliteReadPagesService.mockLoadListOfUserReadPages(
            listOfUserReadPages: userReadPagesFromToday,
          );
          sqliteReadPagesService.mockAddReadPages();

          final DbDay dbDay = await service.addReadPagesForUser(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => sqliteReadPagesService.addReadPages(
              sqliteReadPages: readPagesToAdd,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );

      test(
        'book has been read today, should update read pages and should return db day with all read pages',
        () async {
          final SqliteReadPages bookReadPages = createSqliteReadPages(
            userId: userId,
            date: todayDateStr,
            bookId: bookId,
            readPagesAmount: 100,
          );
          final List<SqliteReadPages> userReadPagesFromToday = [
            bookReadPages,
            createSqliteReadPages(
              userId: userId,
              date: todayDateStr,
              bookId: 'b2',
              readPagesAmount: 40,
            ),
          ];
          final int newAmount = bookReadPages.readPagesAmount + readPagesAmount;
          final SqliteReadPages updatedReadPages =
              bookReadPages.copyWithReadPagesAmount(newAmount);
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: todayDateStr,
            booksWithReadPages: [
              createDbDayBook(bookId: bookId, readPagesAmount: newAmount),
              createDbDayBook(bookId: 'b2', readPagesAmount: 40),
            ],
          );
          sqliteReadPagesService.mockLoadListOfUserReadPages(
            listOfUserReadPages: userReadPagesFromToday,
          );
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
