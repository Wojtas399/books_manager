import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_read_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/firebase/mock_firebase_firestore_user_service.dart';
import '../../../mocks/providers/mock_date_provider.dart';

void main() {
  final firebaseFirestoreUserService = MockFirebaseFirestoreUserService();
  final dateProvider = MockDateProvider();
  late DayRemoteDbService service;

  String mapDateTimeToString(DateTime dateTime) {
    return DateMapper.mapFromDateTimeToString(dateTime);
  }

  setUp(() {
    service = DayRemoteDbService(
      firebaseFirestoreUserService: firebaseFirestoreUserService,
      dateProvider: dateProvider,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreUserService);
    reset(dateProvider);
  });

  test(
    'load user days, should load user and convert his days to db models',
    () async {
      const String userId = 'u1';
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        daysOfReading: [
          createFirebaseDay(
            userId: userId,
            date: mapDateTimeToString(DateTime(2022, 9, 20)),
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
            date: mapDateTimeToString(DateTime(2022, 9, 18)),
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
          date: mapDateTimeToString(DateTime(2022, 9, 20)),
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
          date: mapDateTimeToString(DateTime(2022, 9, 18)),
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
    'add user read book',
    () {
      const String userId = 'u1';
      const String bookId = 'b1';
      const int readPagesAmount = 20;

      test(
        'today date is not in user days of reading, should add new day to user days of reading',
        () async {
          final DateTime todayDate = DateTime(2022, 9, 23);
          final FirebaseReadBook newReadBook = createFirebaseReadBook(
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );
          final FirebaseDay newDay = createFirebaseDay(
            date: mapDateTimeToString(todayDate),
            userId: userId,
            readBooks: [newReadBook],
          );
          final List<FirebaseDay> originalDays = [
            createFirebaseDay(
              date: mapDateTimeToString(DateTime(2022, 9, 20)),
            ),
            createFirebaseDay(
              date: mapDateTimeToString(DateTime(2022, 9, 18)),
            ),
          ];
          final List<FirebaseDay> updatedDays = [...originalDays];
          updatedDays.add(newDay);
          final FirebaseUser firebaseUser = createFirebaseUser(
            daysOfReading: originalDays,
          );
          dateProvider.mockGetNow(nowDateTime: todayDate);
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);
          firebaseFirestoreUserService.mockUpdateUser();

          await service.addUserReadBook(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => firebaseFirestoreUserService.updateUser(
              userId: userId,
              daysOfReading: updatedDays,
            ),
          ).called(1);
        },
      );

      test(
        'today date is in user days of reading, book has not been read today, should add new read book to today date',
        () async {
          final DateTime todayDate = DateTime(2022, 9, 23);
          final FirebaseDay todayDay = createFirebaseDay(
            date: mapDateTimeToString(todayDate),
            readBooks: [
              createFirebaseReadBook(
                bookId: 'b2',
                readPagesAmount: 100,
              ),
            ],
          );
          final List<FirebaseDay> originalDays = [
            todayDay,
            createFirebaseDay(
              date: mapDateTimeToString(DateTime(2022, 9, 15)),
            ),
          ];
          final List<FirebaseDay> updatedDays = [
            todayDay.copyWith(
              readBooks: [
                todayDay.readBooks.first,
                createFirebaseReadBook(
                  bookId: 'b1',
                  readPagesAmount: 20,
                ),
              ],
            ),
            originalDays.last,
          ];
          FirebaseUser firebaseUser = createFirebaseUser(
            daysOfReading: originalDays,
          );
          dateProvider.mockGetNow(nowDateTime: todayDate);
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);
          firebaseFirestoreUserService.mockUpdateUser();

          await service.addUserReadBook(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => firebaseFirestoreUserService.updateUser(
              userId: userId,
              daysOfReading: updatedDays,
            ),
          ).called(1);
        },
      );

      test(
        'today date is in user days of reading, book has been read today, should update read pages amount of read book',
        () async {
          final DateTime todayDate = DateTime(2022, 9, 23);
          final FirebaseDay todayDay = createFirebaseDay(
            date: mapDateTimeToString(todayDate),
            readBooks: [
              createFirebaseReadBook(
                bookId: 'b1',
                readPagesAmount: 100,
              ),
            ],
          );
          final List<FirebaseDay> originalDays = [
            todayDay,
            createFirebaseDay(
              date: mapDateTimeToString(DateTime(2022, 9, 15)),
            ),
          ];
          final List<FirebaseDay> updatedDays = [
            todayDay.copyWith(
              readBooks: [
                todayDay.readBooks.first.copyWith(
                  readPagesAmount: 120,
                ),
              ],
            ),
            originalDays.last,
          ];
          FirebaseUser firebaseUser = createFirebaseUser(
            daysOfReading: originalDays,
          );
          dateProvider.mockGetNow(nowDateTime: todayDate);
          firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);
          firebaseFirestoreUserService.mockUpdateUser();

          await service.addUserReadBook(
            userId: userId,
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );

          verify(
            () => firebaseFirestoreUserService.updateUser(
              userId: userId,
              daysOfReading: updatedDays,
            ),
          ).called(1);
        },
      );
    },
  );
}
