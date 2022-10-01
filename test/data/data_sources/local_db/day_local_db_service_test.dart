import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/sqlite/mock_sqlite_read_book_service.dart';

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
      final List<DbDay> expectedDbDays = [
        createDbDay(
          userId: userId,
          date: '23-09-2022',
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 20),
            createDbReadBook(bookId: 'b2', readPagesAmount: 10),
          ],
        ),
        createDbDay(
          userId: userId,
          date: '20-09-2022',
          readBooks: [
            createDbReadBook(bookId: 'b1', readPagesAmount: 50),
            createDbReadBook(bookId: 'b2', readPagesAmount: 100),
          ],
        ),
        createDbDay(
          userId: userId,
          date: '18-09-2022',
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

  test(
    'add user read book, should call method responsible for adding new read book to sqlite',
    () async {
      final DbReadBook dbReadBook = createDbReadBook(
        bookId: 'b1',
        readPagesAmount: 20,
      );
      const String userId = 'u1';
      const String date = '20-09-2022';
      const SyncState syncState = SyncState.added;
      final SqliteReadBook sqliteReadBook = createSqliteReadBook(
        userId: userId,
        date: date,
        bookId: dbReadBook.bookId,
        readPagesAmount: dbReadBook.readPagesAmount,
        syncState: syncState,
      );
      sqliteReadBookService.mockAddReadBook();

      await service.addUserReadBook(
        dbReadBook: dbReadBook,
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

  group(
    'add new read pages',
    () {
      const String userId = 'u1';
      const String date = '20-09-2022';
      const String bookId = 'b1';
      const int amountOfReadPagesToAdd = 50;

      test(
        'without modified sync state, read book with given id, user id and date exists in sqlite db, should call method responsible for updating read book with read pages amount increased by given read pages amount and sync state set as none and should return day with given date',
        () async {
          final SqliteReadBook existingReadBook = createSqliteReadBook(
            userId: userId,
            date: date,
            bookId: bookId,
            readPagesAmount: 100,
          );
          final SqliteReadBook updatedReadBook = existingReadBook.copyWith(
            readPagesAmount:
                existingReadBook.readPagesAmount + amountOfReadPagesToAdd,
          );
          final List<SqliteReadBook> userReadBooksAfterActualisation = [
            updatedReadBook,
            createSqliteReadBook(
              userId: userId,
              date: date,
              bookId: 'b2',
              readPagesAmount: 200,
            ),
          ];
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: date,
            readBooks: [
              createDbReadBook(
                bookId: updatedReadBook.bookId,
                readPagesAmount: updatedReadBook.readPagesAmount,
              ),
              createDbReadBook(bookId: 'b2', readPagesAmount: 200),
            ],
          );
          sqliteReadBookService.mockLoadReadBook(readBook: existingReadBook);
          sqliteReadBookService.mockUpdateReadBook();
          sqliteReadBookService.mockLoadUserReadBooks(
            userReadBooks: userReadBooksAfterActualisation,
          );

          final DbDay dbDay = await service.addNewReadPages(
            userId: userId,
            date: date,
            bookId: bookId,
            amountOfReadPagesToAdd: amountOfReadPagesToAdd,
          );

          verify(
            () => sqliteReadBookService.loadReadBook(
              userId: userId,
              date: date,
              bookId: bookId,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.updateReadBook(
              userId: userId,
              date: date,
              bookId: updatedReadBook.bookId,
              readPagesAmount: updatedReadBook.readPagesAmount,
              syncState: SyncState.none,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.loadUserReadBooks(
              userId: userId,
              date: date,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );

      test(
        'with modified sync state, read book with given id, user id and date exists in sqlite db, should call method responsible for updating read book with read pages amount increased by given read pages amount and sync state set as updated and should return day with given date',
        () async {
          final SqliteReadBook existingReadBook = createSqliteReadBook(
            userId: userId,
            date: date,
            bookId: bookId,
            readPagesAmount: 100,
          );
          final SqliteReadBook updatedReadBook = existingReadBook.copyWith(
            readPagesAmount:
                existingReadBook.readPagesAmount + amountOfReadPagesToAdd,
          );
          final List<SqliteReadBook> userReadBooksAfterActualisation = [
            updatedReadBook,
            createSqliteReadBook(
              userId: userId,
              date: date,
              bookId: 'b2',
              readPagesAmount: 200,
            ),
          ];
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: date,
            readBooks: [
              createDbReadBook(
                bookId: updatedReadBook.bookId,
                readPagesAmount: updatedReadBook.readPagesAmount,
              ),
              createDbReadBook(bookId: 'b2', readPagesAmount: 200),
            ],
          );
          sqliteReadBookService.mockLoadReadBook(readBook: existingReadBook);
          sqliteReadBookService.mockUpdateReadBook();
          sqliteReadBookService.mockLoadUserReadBooks(
            userReadBooks: userReadBooksAfterActualisation,
          );

          final DbDay dbDay = await service.addNewReadPages(
            userId: userId,
            date: date,
            bookId: bookId,
            amountOfReadPagesToAdd: amountOfReadPagesToAdd,
            withModifiedSyncState: true,
          );

          verify(
            () => sqliteReadBookService.loadReadBook(
              userId: userId,
              date: date,
              bookId: bookId,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.updateReadBook(
              userId: userId,
              date: date,
              bookId: updatedReadBook.bookId,
              readPagesAmount: updatedReadBook.readPagesAmount,
              syncState: SyncState.updated,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.loadUserReadBooks(
              userId: userId,
              date: date,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );

      test(
        'without modified sync state, read book with given id, user id and date does not exist in sqlite db, should call method responsible for adding new read book to sqlite with sync state set as none and should return day with given date',
        () async {
          final SqliteReadBook sqliteReadBook = createSqliteReadBook(
            userId: userId,
            date: date,
            bookId: bookId,
            readPagesAmount: amountOfReadPagesToAdd,
            syncState: SyncState.none,
          );
          final List<SqliteReadBook> userReadBooksAfterActualisation = [
            sqliteReadBook,
            createSqliteReadBook(
              userId: userId,
              date: date,
              bookId: 'b2',
              readPagesAmount: 200,
            ),
          ];
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: date,
            readBooks: [
              createDbReadBook(
                bookId: sqliteReadBook.bookId,
                readPagesAmount: sqliteReadBook.readPagesAmount,
              ),
              createDbReadBook(bookId: 'b2', readPagesAmount: 200),
            ],
          );
          sqliteReadBookService.mockLoadReadBook();
          sqliteReadBookService.mockAddReadBook();
          sqliteReadBookService.mockLoadUserReadBooks(
            userReadBooks: userReadBooksAfterActualisation,
          );

          final DbDay dbDay = await service.addNewReadPages(
            userId: userId,
            date: date,
            bookId: bookId,
            amountOfReadPagesToAdd: amountOfReadPagesToAdd,
          );

          verify(
            () => sqliteReadBookService.loadReadBook(
              userId: userId,
              date: date,
              bookId: bookId,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.addReadBook(
              sqliteReadBook: sqliteReadBook,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.loadUserReadBooks(
              userId: userId,
              date: date,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );

      test(
        'with modified sync state, read book with given id, user id and date does not exist in sqlite db, should call method responsible for adding new read book to sqlite with sync state set as added and should return day with given date',
        () async {
          final SqliteReadBook sqliteReadBook = createSqliteReadBook(
            userId: userId,
            date: date,
            bookId: bookId,
            readPagesAmount: amountOfReadPagesToAdd,
            syncState: SyncState.added,
          );
          final List<SqliteReadBook> userReadBooksAfterActualisation = [
            sqliteReadBook,
            createSqliteReadBook(
              userId: userId,
              date: date,
              bookId: 'b2',
              readPagesAmount: 200,
            ),
          ];
          final DbDay expectedDbDay = createDbDay(
            userId: userId,
            date: date,
            readBooks: [
              createDbReadBook(
                bookId: sqliteReadBook.bookId,
                readPagesAmount: sqliteReadBook.readPagesAmount,
              ),
              createDbReadBook(bookId: 'b2', readPagesAmount: 200),
            ],
          );
          sqliteReadBookService.mockLoadReadBook();
          sqliteReadBookService.mockAddReadBook();
          sqliteReadBookService.mockLoadUserReadBooks(
            userReadBooks: userReadBooksAfterActualisation,
          );

          final DbDay dbDay = await service.addNewReadPages(
            userId: userId,
            date: date,
            bookId: bookId,
            amountOfReadPagesToAdd: amountOfReadPagesToAdd,
            withModifiedSyncState: true,
          );

          verify(
            () => sqliteReadBookService.loadReadBook(
              userId: userId,
              date: date,
              bookId: bookId,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.addReadBook(
              sqliteReadBook: sqliteReadBook,
            ),
          ).called(1);
          verify(
            () => sqliteReadBookService.loadUserReadBooks(
              userId: userId,
              date: date,
            ),
          ).called(1);
          expect(dbDay, expectedDbDay);
        },
      );
    },
  );
}
