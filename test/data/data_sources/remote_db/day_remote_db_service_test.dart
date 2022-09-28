import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_read_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/firebase/mock_firebase_firestore_user_service.dart';

void main() {
  final firebaseFirestoreUserService = MockFirebaseFirestoreUserService();
  late DayRemoteDbService service;
  const String userId = 'u1';

  setUp(() {
    service = DayRemoteDbService(
      firebaseFirestoreUserService: firebaseFirestoreUserService,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreUserService);
  });

  test(
    'load user days, should load user and convert his days to db models',
    () async {
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        daysOfReading: [
          createFirebaseDay(
            userId: userId,
            date: '20-09-2022',
            readBooks: [
              createFirebaseReadBook(
                bookId: 'b1',
                readPagesAmount: 20,
              ),
              createFirebaseReadBook(
                bookId: 'b2',
                readPagesAmount: 100,
              ),
            ],
          ),
          createFirebaseDay(
            userId: userId,
            date: '18-09-2022',
            readBooks: [
              createFirebaseReadBook(
                bookId: 'b1',
                readPagesAmount: 120,
              ),
            ],
          ),
        ],
      );
      final List<DbDay> expectedDbDays = [
        createDbDay(
          userId: userId,
          date: '20-09-2022',
          readBooks: [
            createDbReadBook(
              bookId: 'b1',
              readPagesAmount: 20,
            ),
            createDbReadBook(
              bookId: 'b2',
              readPagesAmount: 100,
            ),
          ],
        ),
        createDbDay(
          userId: userId,
          date: '18-09-2022',
          readBooks: [
            createDbReadBook(
              bookId: 'b1',
              readPagesAmount: 120,
            ),
          ],
        ),
      ];
      firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

      final List<DbDay> dbDays = await service.loadUserDays(userId: userId);

      expect(dbDays, expectedDbDays);
    },
  );

  group(
    'add user read book, ',
    () {
      final DbReadBook dbReadBook = createDbReadBook(
        bookId: 'b1',
        readPagesAmount: 50,
      );
      const String date = '20-09-2022';

      Future<void> callAddUserReadBookMethod() async {
        await service.addUserReadBook(
          dbReadBook: dbReadBook,
          userId: userId,
          date: date,
        );
      }

      setUp(() {
        firebaseFirestoreUserService.mockUpdateUser();
      });

      test(
        'given date exists in user days, book exists in day, should throw error',
        () async {
          final List<FirebaseDay> daysOfReading = [
            createFirebaseDay(
              userId: userId,
              date: date,
              readBooks: [
                createFirebaseReadBook(
                  bookId: dbReadBook.bookId,
                  readPagesAmount: 100,
                ),
              ],
            ),
          ];
          final FirebaseUser firebaseUser = createFirebaseUser(
            id: userId,
            daysOfReading: daysOfReading,
          );
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

          try {
            await callAddUserReadBookMethod();
          } catch (error) {
            expect(
              error,
              '(Firebase firestore) Book with id ${dbReadBook.bookId} already exists in day $date',
            );
          }
        },
      );

      test(
        'given date exists in user days, book does not exist in day, should add new read book',
        () async {
          final List<FirebaseDay> originalDaysOfReading = [
            createFirebaseDay(
              userId: userId,
              date: date,
              readBooks: [
                createFirebaseReadBook(bookId: 'b2', readPagesAmount: 200),
              ],
            ),
          ];
          final List<FirebaseDay> updatedDaysOfReading = [
            originalDaysOfReading.first.copyWith(
              readBooks: [
                originalDaysOfReading.first.readBooks.first,
                createFirebaseReadBook(
                  bookId: dbReadBook.bookId,
                  readPagesAmount: dbReadBook.readPagesAmount,
                ),
              ],
            ),
          ];
          final FirebaseUser firebaseUser = createFirebaseUser(
            id: userId,
            daysOfReading: originalDaysOfReading,
          );
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

          await callAddUserReadBookMethod();

          verify(
            () => firebaseFirestoreUserService.updateUser(
              userId: userId,
              daysOfReading: updatedDaysOfReading,
            ),
          ).called(1);
        },
      );

      test(
        'given date does not exist in user days, should add new day with one read book',
        () async {
          final List<FirebaseDay> originalDaysOfReading = [
            createFirebaseDay(date: '18-09-2022'),
          ];
          final List<FirebaseDay> updatedDaysOfReading = [
            originalDaysOfReading.first,
            createFirebaseDay(
              userId: userId,
              date: date,
              readBooks: [
                createFirebaseReadBook(
                  bookId: dbReadBook.bookId,
                  readPagesAmount: dbReadBook.readPagesAmount,
                ),
              ],
            ),
          ];
          final FirebaseUser firebaseUser = createFirebaseUser(
            id: userId,
            daysOfReading: originalDaysOfReading,
          );
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

          await callAddUserReadBookMethod();

          verify(
            () => firebaseFirestoreUserService.updateUser(
              userId: userId,
              daysOfReading: updatedDaysOfReading,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'update book read pages amount in day',
    () {
      final DbReadBook updatedDbReadBook = createDbReadBook(
        bookId: 'b1',
        readPagesAmount: 120,
      );
      const String date = '20-09-2022';

      Future<void> callUpdateBookReadPagesAmountInDayMethod() async {
        await service.updateBookReadPagesAmountInDay(
          updatedDbReadBook: updatedDbReadBook,
          userId: userId,
          date: date,
        );
      }

      test(
        'given date does not exist in user days of reading, should throw error',
        () async {
          final List<FirebaseDay> daysOfReading = [
            createFirebaseDay(date: '18-09-2022'),
            createFirebaseDay(date: '15-09-2022'),
          ];
          final FirebaseUser firebaseUser = createFirebaseUser(
            daysOfReading: daysOfReading,
          );
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

          try {
            await callUpdateBookReadPagesAmountInDayMethod();
          } catch (error) {
            expect(
              error,
              "(Firebase firestore) There is no day with date $date in user's days of reading",
            );
          }
        },
      );

      test(
        'given date exists in user days of reading, book does not exist in read books from the day, should throw error',
        () async {
          final List<FirebaseDay> daysOfReading = [
            createFirebaseDay(
              date: date,
              readBooks: [
                createFirebaseReadBook(bookId: 'b2'),
                createFirebaseReadBook(bookId: 'b3'),
              ],
            ),
          ];
          final FirebaseUser firebaseUser = createFirebaseUser(
            daysOfReading: daysOfReading,
          );
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

          try {
            await callUpdateBookReadPagesAmountInDayMethod();
          } catch (error) {
            "(Firebase firestore) There is no book with id ${updatedDbReadBook.bookId} in read books from the day $date";
          }
        },
      );

      test(
        'given date exists in user days of reading, book exists in read books from the day, should update read book',
        () async {
          final List<FirebaseDay> originalDaysOfReading = [
            createFirebaseDay(
              date: date,
              readBooks: [
                createFirebaseReadBook(
                  bookId: updatedDbReadBook.bookId,
                  readPagesAmount: 50,
                ),
              ],
            ),
          ];
          final List<FirebaseDay> updatedDaysOfReading = [
            createFirebaseDay(
              date: date,
              readBooks: [
                createFirebaseReadBook(
                  bookId: updatedDbReadBook.bookId,
                  readPagesAmount: updatedDbReadBook.readPagesAmount,
                )
              ],
            ),
          ];
          final FirebaseUser firebaseUser = createFirebaseUser(
            daysOfReading: originalDaysOfReading,
          );
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);
          firebaseFirestoreUserService.mockUpdateUser();

          await callUpdateBookReadPagesAmountInDayMethod();

          verify(
            () => firebaseFirestoreUserService.updateUser(
              userId: userId,
              daysOfReading: updatedDaysOfReading,
            ),
          ).called(1);
        },
      );
    },
  );
}
