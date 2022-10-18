import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/data/local_db/sqlite/mock_sqlite_read_book_service.dart';

void main() {
  final sqliteReadBookService = MockSqliteReadBookService();
  late DayLocalDbService service;

  setUp(() {
    service = DayLocalDbService(
      sqliteReadBookService: sqliteReadBookService,
    );
  });

  tearDown(() {
    reset(sqliteReadBookService);
  });

  test(
    'load user days, should load all read books belonging to user and should segregate them to list of db days',
    () async {
      const String userId = 'userId';
      final List<SqliteReadBook> readBooks = [
        createSqliteReadBook(
          userId: userId,
          date: '23-09-2022',
          bookId: 'b1',
          readPagesAmount: 20,
        ),
        createSqliteReadBook(
          userId: userId,
          date: '20-09-2022',
          bookId: 'b1',
          readPagesAmount: 50,
        ),
        createSqliteReadBook(
          userId: userId,
          date: '20-09-2022',
          bookId: 'b2',
          readPagesAmount: 100,
        ),
        createSqliteReadBook(
          userId: userId,
          date: '18-08-2022',
          bookId: 'b2',
          readPagesAmount: 100,
        ),
        createSqliteReadBook(
          userId: userId,
          date: '23-09-2022',
          bookId: 'b2',
          readPagesAmount: 10,
        ),
      ];
      final List<Day> expectedDays = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 23),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 20),
            createReadBook(bookId: 'b2', readPagesAmount: 10),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 50),
            createReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 8, 18),
          readBooks: [
            createReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
      ];
      sqliteReadBookService.mockLoadUserReadBooks(userReadBooks: readBooks);

      final List<Day> days = await service.loadUserDays(userId: userId);

      expect(days, expectedDays);
    },
  );

  test(
    'load user days from month, should load user read books from month and should segregate them to list of db days',
    () async {
      const String userId = 'userId';
      const int month = 9;
      const int year = 2022;
      final List<SqliteReadBook> readBooksFromMonth = [
        createSqliteReadBook(
          userId: userId,
          date: '23-09-2022',
          bookId: 'b1',
          readPagesAmount: 20,
        ),
        createSqliteReadBook(
          userId: userId,
          date: '20-09-2022',
          bookId: 'b1',
          readPagesAmount: 50,
        ),
        createSqliteReadBook(
          userId: userId,
          date: '18-09-2022',
          bookId: 'b2',
          readPagesAmount: 100,
        ),
        createSqliteReadBook(
          userId: userId,
          date: '23-09-2022',
          bookId: 'b2',
          readPagesAmount: 10,
        ),
      ];
      final List<Day> expectedDaysFromMonth = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 23),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 20),
            createReadBook(bookId: 'b2', readPagesAmount: 10),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 50),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 18),
          readBooks: [
            createReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
      ];
      sqliteReadBookService.mockLoadUserReadBooksFromMonth(
        userReadBooksFromMonth: readBooksFromMonth,
      );

      final List<Day> daysFromMonth = await service.loadUserDaysFromMonth(
        userId: userId,
        month: month,
        year: year,
      );

      expect(daysFromMonth, expectedDaysFromMonth);
    },
  );

  test(
    'add day, should add every read book from day to sqlite',
    () async {
      final Day dayToAdd = createDay(
        date: DateTime(2022, 10, 15),
        userId: 'u1',
        readBooks: [
          createReadBook(bookId: 'b1', readPagesAmount: 100),
          createReadBook(bookId: 'b2', readPagesAmount: 200),
        ],
      );
      const SyncState syncState = SyncState.added;
      final SqliteReadBook sqliteReadBook1 = createSqliteReadBook(
        userId: dayToAdd.userId,
        date: DateMapper.mapFromDateTimeToString(dayToAdd.date),
        bookId: dayToAdd.readBooks.first.bookId,
        readPagesAmount: dayToAdd.readBooks.first.readPagesAmount,
        syncState: syncState,
      );
      final SqliteReadBook sqliteReadBook2 = createSqliteReadBook(
        userId: dayToAdd.userId,
        date: DateMapper.mapFromDateTimeToString(dayToAdd.date),
        bookId: dayToAdd.readBooks.last.bookId,
        readPagesAmount: dayToAdd.readBooks.last.readPagesAmount,
        syncState: syncState,
      );
      sqliteReadBookService.mockAddReadBook();

      await service.addDay(
        day: dayToAdd,
        syncState: syncState,
      );

      verify(
        () => sqliteReadBookService.addReadBook(
          sqliteReadBook: sqliteReadBook1,
        ),
      ).called(1);
      verify(
        () => sqliteReadBookService.addReadBook(
          sqliteReadBook: sqliteReadBook2,
        ),
      ).called(1);
    },
  );

  test(
    'update day, should update every read book in sqlite',
    () async {
      final Day updatedDay = createDay(
        date: DateTime(2022, 10, 15),
        userId: 'u1',
        readBooks: [
          createReadBook(bookId: 'b1', readPagesAmount: 100),
          createReadBook(bookId: 'b2', readPagesAmount: 200),
        ],
      );
      const SyncState syncState = SyncState.updated;
      sqliteReadBookService.mockUpdateReadBook();

      await service.updateDay(
        updatedDay: updatedDay,
        syncState: syncState,
      );

      verify(
        () => sqliteReadBookService.updateReadBook(
          userId: updatedDay.userId,
          date: DateMapper.mapFromDateTimeToString(updatedDay.date),
          bookId: updatedDay.readBooks.first.bookId,
          readPagesAmount: updatedDay.readBooks.first.readPagesAmount,
          syncState: syncState,
        ),
      ).called(1);
      verify(
        () => sqliteReadBookService.updateReadBook(
          userId: updatedDay.userId,
          date: DateMapper.mapFromDateTimeToString(updatedDay.date),
          bookId: updatedDay.readBooks.last.bookId,
          readPagesAmount: updatedDay.readBooks.last.readPagesAmount,
          syncState: syncState,
        ),
      ).called(1);
    },
  );

  test(
    'delete day, should delete read books from given date from sqlite',
    () async {
      const String userId = 'u1';
      final DateTime date = DateTime(2022, 10, 18);
      sqliteReadBookService.mockDeleteReadBooksFromDate();

      await service.deleteDay(userId: userId, date: date);

      verify(
        () => sqliteReadBookService.deleteReadBooksFromDate(
          userId: userId,
          date: DateMapper.mapFromDateTimeToString(date),
        ),
      ).called(1);
    },
  );
}
