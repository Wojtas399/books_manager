import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/providers/mock_date_provider.dart';
import '../../../mocks/sqlite/mock_sqlite_read_book_service.dart';

void main() {
  final sqliteReadBookService = MockSqliteReadBookService();
  final dateProvider = MockDateProvider();
  late DayLocalDbService service;

  String mapDateTimeToString(DateTime dateTime) {
    return DateMapper.mapFromDateTimeToString(dateTime);
  }

  setUp(() {
    service = DayLocalDbService(
      sqliteReadBookService: sqliteReadBookService,
      dateProvider: dateProvider,
    );
  });

  tearDown(() {
    reset(sqliteReadBookService);
    reset(dateProvider);
  });

  test(
    'load user days, should load all read books belonging to user and should segregate them to list of db days',
    () async {
      const String userId = 'userId';
      final List<SqliteReadBook> readBooks = [
        createSqliteReadBook(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 23)),
          bookId: 'b1',
          readPagesAmount: 20,
        ),
        createSqliteReadBook(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
          bookId: 'b1',
          readPagesAmount: 50,
        ),
        createSqliteReadBook(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
          bookId: 'b2',
          readPagesAmount: 100,
        ),
        createSqliteReadBook(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 18)),
          bookId: 'b2',
          readPagesAmount: 100,
        ),
        createSqliteReadBook(
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
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 20),
            createDbReadBook(bookId: 'b2', readPagesAmount: 10),
          ],
        ),
        createDbDay(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 50),
            createDbReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
        createDbDay(
          userId: userId,
          date: mapDateTimeToString(DateTime(2022, 9, 18)),
          readBooks: [
            createDbReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
      ];
      sqliteReadBookService.mockLoadUserReadBooks(userReadBooks: readBooks);

      final List<DbDay> dbDays = await service.loadUserDays(userId: userId);

      expect(dbDays, expectedDbDays);
    },
  );

  group(
    'add user read book',
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
        'book has not been read today, should add new read book and should return db day with all read books from today',
        () async {
          final SqliteReadBook readBookToAdd = createSqliteReadBook(
            userId: userId,
            bookId: bookId,
            date: todayDateStr,
            readPagesAmount: readPagesAmount,
          );
          final List<SqliteReadBook> userReadBooksFromToday = [
            createSqliteReadBook(
              userId: userId,
              bookId: 'b2',
              date: todayDateStr,
              readPagesAmount: 100,
            ),
            createSqliteReadBook(
              userId: userId,
              bookId: 'b3',
              date: todayDateStr,
              readPagesAmount: 40,
            ),
          ];
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: todayDateStr,
            readBooks: [
              createDbReadBook(bookId: 'b2', readPagesAmount: 100),
              createDbReadBook(bookId: 'b3', readPagesAmount: 40),
              createDbReadBook(
                bookId: bookId,
                readPagesAmount: readPagesAmount,
              ),
            ],
          );
          sqliteReadBookService.mockLoadUserReadBooks(
            userReadBooks: userReadBooksFromToday,
          );
          sqliteReadBookService.mockAddReadBook();

          final DbDay dbDay = await service.addUserReadBook(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => sqliteReadBookService.addReadBook(
              sqliteReadBook: readBookToAdd,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );

      test(
        'book has been read today, should update read pages amount in read book and should return db day with all read books from today',
        () async {
          final SqliteReadBook readBook = createSqliteReadBook(
            userId: userId,
            date: todayDateStr,
            bookId: bookId,
            readPagesAmount: 100,
          );
          final List<SqliteReadBook> userReadBooksFromToday = [
            readBook,
            createSqliteReadBook(
              userId: userId,
              date: todayDateStr,
              bookId: 'b2',
              readPagesAmount: 40,
            ),
          ];
          final int newAmount = readBook.readPagesAmount + readPagesAmount;
          final SqliteReadBook updatedReadBook =
              readBook.copyWithReadPagesAmount(newAmount);
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: todayDateStr,
            readBooks: [
              createDbReadBook(bookId: bookId, readPagesAmount: newAmount),
              createDbReadBook(bookId: 'b2', readPagesAmount: 40),
            ],
          );
          sqliteReadBookService.mockLoadUserReadBooks(
            userReadBooks: userReadBooksFromToday,
          );
          sqliteReadBookService.mockUpdateReadBook();

          final DbDay dbDay = await service.addUserReadBook(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => sqliteReadBookService.updateReadBook(
              updatedSqliteReadBook: updatedReadBook,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );
    },
  );
}
