import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/models/db_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/firebase/mock_firebase_firestore_user_service.dart';
import '../../../mocks/providers/mock_date_provider.dart';

void main() {
  final firebaseFirestoreUserService = MockFirebaseFirestoreUserService();
  final dateProvider = MockDateProvider();
  late UserRemoteDbService service;

  String mapDateTimeToString(DateTime dateTime) {
    return DateMapper.mapFromDateTimeToString(dateTime);
  }

  setUp(() {
    service = UserRemoteDbService(
      firebaseFirestoreUserService: firebaseFirestoreUserService,
      dateProvider: dateProvider,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreUserService);
    reset(dateProvider);
  });

  test(
    'load user, should load user from firebase firestore',
    () async {
      const String userId = 'u1';
      final FirebaseUser firebaseUser = createFirebaseUser(id: userId);
      final DbUser expectedDbUser = createDbUser(
        id: firebaseUser.id,
        isDarkModeOn: firebaseUser.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            firebaseUser.isDarkModeCompatibilityWithSystemOn,
      );
      firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

      final DbUser dbUser = await service.loadUser(userId: userId);

      expect(dbUser, expectedDbUser);
    },
  );

  test(
    'add book, should call method responsible for adding user to firebase firestore',
    () async {
      final DbUser dbUserToAdd = createDbUser(id: 'u1');
      final FirebaseUser firebaseUserToAdd = createFirebaseUser(
        id: dbUserToAdd.id,
        isDarkModeOn: dbUserToAdd.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            dbUserToAdd.isDarkModeCompatibilityWithSystemOn,
      );
      firebaseFirestoreUserService.mockAddUser();

      await service.addUser(dbUser: dbUserToAdd);

      verify(
        () => firebaseFirestoreUserService.addUser(
          firebaseUser: firebaseUserToAdd,
        ),
      ).called(1);
    },
  );

  test(
    'update user, should call method responsible for updating user in firebase firestore',
    () async {
      const String userId = 'u1';
      const bool isDarkModeOn = true;
      const bool isDarkModeCompatibilityWithSystemOn = false;
      firebaseFirestoreUserService.mockUpdateUser();

      await service.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );

      verify(
        () => firebaseFirestoreUserService.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
        ),
      ).called(1);
    },
  );

  group(
    'add read pages for user',
    () {
      const String userId = 'u1';
      const String bookId = 'b1';
      const int readPagesAmount = 20;

      test(
        'today date is not in user days of reading, should add new day to user days of reading',
        () async {
          final DateTime todayDate = DateTime(2022, 9, 23);
          final FirebaseDayBook newDayBook = createFirebaseDayBook(
            bookId: bookId,
            readPagesAmount: readPagesAmount,
          );
          final FirebaseDay newDay = createFirebaseDay(
            date: mapDateTimeToString(todayDate),
            userId: userId,
            booksWithReadPages: [newDayBook],
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

          await service.addReadPagesForUser(
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
        'today date is in user days of reading, book has not been read today, should add new day book to today date',
        () async {
          final DateTime todayDate = DateTime(2022, 9, 23);
          final FirebaseDay todayDay = createFirebaseDay(
            date: mapDateTimeToString(todayDate),
            booksWithReadPages: [
              createFirebaseDayBook(
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
              booksWithReadPages: [
                todayDay.booksWithReadPages.first,
                createFirebaseDayBook(
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

          await service.addReadPagesForUser(
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
        'today date is in user days of reading, book has been read today, should update read pages amount of book',
        () async {
          final DateTime todayDate = DateTime(2022, 9, 23);
          final FirebaseDay todayDay = createFirebaseDay(
            date: mapDateTimeToString(todayDate),
            booksWithReadPages: [
              createFirebaseDayBook(
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
              booksWithReadPages: [
                todayDay.booksWithReadPages.first.copyWith(
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

          await service.addReadPagesForUser(
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

  test(
    'delete user, should call method responsible for deleting user from firebase firestore',
    () async {
      const String userId = 'u1';
      firebaseFirestoreUserService.mockDeleteUser();

      await service.deleteUser(userId: userId);

      verify(
        () => firebaseFirestoreUserService.deleteUser(userId: userId),
      ).called(1);
    },
  );
}
