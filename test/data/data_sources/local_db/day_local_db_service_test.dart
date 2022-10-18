import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
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
    'add user read book, should call method responsible for adding new read book to sqlite',
    () async {
      final ReadBook readBook = createReadBook(
        bookId: 'b1',
        readPagesAmount: 20,
      );
      const String userId = 'u1';
      const String date = '20-09-2022';
      const SyncState syncState = SyncState.added;
      final SqliteReadBook sqliteReadBook = createSqliteReadBook(
        userId: userId,
        date: date,
        bookId: readBook.bookId,
        readPagesAmount: readBook.readPagesAmount,
        syncState: syncState,
      );
      sqliteReadBookService.mockAddReadBook();

      await service.addUserReadBook(
        readBook: readBook,
        userId: userId,
        date: date,
        syncState: syncState,
      );

      verify(
        () => sqliteReadBookService.addReadBook(
          sqliteReadBook: sqliteReadBook,
        ),
      ).called(1);
    },
  );

  test(
    'update read book, should call method responsible for updating read book in sqlite',
    () async {
      const String userId = 'u1';
      const String date = '20-09-2022';
      const String bookId = 'b1';
      const int readPagesAmount = 130;
      const SyncState syncState = SyncState.added;
      sqliteReadBookService.mockUpdateReadBook();

      await service.updateReadBook(
        userId: userId,
        date: date,
        bookId: bookId,
        readPagesAmount: readPagesAmount,
        syncState: syncState,
      );

      verify(
        () => sqliteReadBookService.updateReadBook(
          userId: userId,
          date: date,
          bookId: bookId,
          readPagesAmount: readPagesAmount,
          syncState: syncState,
        ),
      ).called(1);
    },
  );

  test(
    'delete read book, should call method responsible for deleting read book in sqlite',
    () async {
      const String bookId = 'b1';
      sqliteReadBookService.mockDeleteReadBook();

      await service.deleteReadBook(bookId: bookId);

      verify(
        () => sqliteReadBookService.deleteReadBook(bookId: bookId),
      ).called(1);
    },
  );
}
