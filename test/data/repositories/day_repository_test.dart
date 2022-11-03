import 'package:app/data/data_sources/firebase/entities/firebase_day.dart';
import 'package:app/data/data_sources/firebase/entities/firebase_read_book.dart';
import 'package:app/data/data_sources/firebase/entities/firebase_user.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/repositories/day_repository.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../mocks/data/firebase/mock_firebase_firestore_user_service.dart';

void main() {
  final firebaseFirestoreUserService = MockFirebaseFirestoreUserService();
  late DayRepository repository;
  const String userId = 'u1';

  setUp(() {
    repository = DayRepository(
      firebaseFirestoreUserService: firebaseFirestoreUserService,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreUserService);
  });

  test(
    'get user days, should query user from firebase firestore and should return all his days of reading',
    () async {
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        daysOfReading: [
          createFirebaseDay(
            userId: userId,
            date: '20-09-2021',
          ),
          createFirebaseDay(
            userId: userId,
            date: '20-08-2022',
          ),
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
      final List<Day> expectedDays = [
        createDay(
          userId: userId,
          date: DateTime(2021, 9, 20),
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 8, 20),
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(
              bookId: 'b1',
              readPagesAmount: 20,
            ),
            createReadBook(
              bookId: 'b2',
              readPagesAmount: 100,
            ),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 18),
          readBooks: [
            createReadBook(
              bookId: 'b1',
              readPagesAmount: 120,
            ),
          ],
        ),
      ];
      firebaseFirestoreUserService.mockGetUser(firebaseUser: firebaseUser);

      final Stream<List<Day>> userDays$ = repository.getUserDays(
        userId: userId,
      );

      expect(await userDays$.first, expectedDays);
      verify(
        () => firebaseFirestoreUserService.getUser(userId: userId),
      ).called(1);
    },
  );

  test(
    'get user days from month, should query user from firebase firestore and should return his days of reading from given month and year',
    () async {
      const int month = 9;
      const int year = 2022;
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        daysOfReading: [
          createFirebaseDay(
            userId: userId,
            date: '20-09-2021',
          ),
          createFirebaseDay(
            userId: userId,
            date: '20-08-2022',
          ),
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
      final List<Day> expectedDays = [
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 20),
          readBooks: [
            createReadBook(
              bookId: 'b1',
              readPagesAmount: 20,
            ),
            createReadBook(
              bookId: 'b2',
              readPagesAmount: 100,
            ),
          ],
        ),
        createDay(
          userId: userId,
          date: DateTime(2022, 9, 18),
          readBooks: [
            createReadBook(
              bookId: 'b1',
              readPagesAmount: 120,
            ),
          ],
        ),
      ];
      firebaseFirestoreUserService.mockGetUser(firebaseUser: firebaseUser);

      final Stream<List<Day>> userDays$ = repository.getUserDaysFromMonth(
        userId: userId,
        month: month,
        year: year,
      );

      expect(await userDays$.first, expectedDays);
      verify(
        () => firebaseFirestoreUserService.getUser(userId: userId),
      ).called(1);
    },
  );

  test(
    'add new day, should add day to user days of reading and then should update user with updated days of reading',
    () async {
      const String userId = 'u1';
      final Day dayToAdd = createDay(
        date: DateTime(2022, 10, 20),
        userId: userId,
        readBooks: [
          createReadBook(bookId: 'b1', readPagesAmount: 20),
        ],
      );
      final FirebaseDay firebaseDayToAdd = createFirebaseDay(
        date: DateMapper.mapFromDateTimeToString(dayToAdd.date),
        userId: dayToAdd.userId,
        readBooks: [
          createFirebaseReadBook(
            bookId: dayToAdd.readBooks.first.bookId,
            readPagesAmount: dayToAdd.readBooks.first.readPagesAmount,
          ),
        ],
      );
      final List<FirebaseDay> userDays = [
        createFirebaseDay(date: '15-10-2022'),
      ];
      final List<FirebaseDay> updatedUserDays = [
        userDays.first,
        firebaseDayToAdd,
      ];
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        daysOfReading: userDays,
      );
      firebaseFirestoreUserService.mockGetUser(firebaseUser: firebaseUser);
      firebaseFirestoreUserService.mockUpdateUser();

      await repository.addNewDay(day: dayToAdd);

      verify(
        () => firebaseFirestoreUserService.getUser(userId: userId),
      ).called(1);
      verify(
        () => firebaseFirestoreUserService.updateUser(
          userId: userId,
          daysOfReading: updatedUserDays,
        ),
      ).called(1);
    },
  );

  test(
    'update day, should update day in user days of reading and then should update user with updated days of reading',
    () async {
      const String userId = 'u1';
      final Day updatedDay = createDay(
        date: DateTime(2022, 10, 20),
        userId: userId,
        readBooks: [
          createReadBook(bookId: 'b1', readPagesAmount: 100),
        ],
      );
      final FirebaseDay originalFirebaseDay = createFirebaseDay(
        date: DateMapper.mapFromDateTimeToString(updatedDay.date),
        userId: updatedDay.userId,
        readBooks: [
          createFirebaseReadBook(
            bookId: updatedDay.readBooks.first.bookId,
            readPagesAmount: 10,
          ),
        ],
      );
      final FirebaseDay updatedFirebaseDay = originalFirebaseDay.copyWith(
        readBooks: [
          createFirebaseReadBook(
            bookId: updatedDay.readBooks.first.bookId,
            readPagesAmount: updatedDay.readBooks.first.readPagesAmount,
          ),
        ],
      );
      final List<FirebaseDay> days = [
        createFirebaseDay(date: '15-10-2022'),
        originalFirebaseDay,
      ];
      final List<FirebaseDay> updatedDays = [
        days.first,
        updatedFirebaseDay,
      ];
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        daysOfReading: days,
      );
      firebaseFirestoreUserService.mockGetUser(firebaseUser: firebaseUser);
      firebaseFirestoreUserService.mockUpdateUser();

      await repository.updateDay(updatedDay: updatedDay);

      verify(
        () => firebaseFirestoreUserService.getUser(userId: userId),
      ).called(1);
      verify(
        () => firebaseFirestoreUserService.updateUser(
          userId: userId,
          daysOfReading: updatedDays,
        ),
      ).called(1);
    },
  );

  test(
    'delete day, should delete day from user days of reading and then should update user with updated days of reading',
    () async {
      const String userId = 'u1';
      final DateTime date = DateTime(2022, 10, 20);
      final List<FirebaseDay> days = [
        createFirebaseDay(
          date: DateMapper.mapFromDateTimeToString(DateTime(2022, 10, 15)),
        ),
        createFirebaseDay(
          date: DateMapper.mapFromDateTimeToString(date),
        ),
        createFirebaseDay(
          date: DateMapper.mapFromDateTimeToString(DateTime(2022, 10, 21)),
        ),
      ];
      final List<FirebaseDay> updatedDays = [days.first, days.last];
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        daysOfReading: days,
      );
      firebaseFirestoreUserService.mockGetUser(firebaseUser: firebaseUser);
      firebaseFirestoreUserService.mockUpdateUser();

      await repository.deleteDay(userId: userId, date: date);

      verify(
        () => firebaseFirestoreUserService.getUser(userId: userId),
      ).called(1);
      verify(
        () => firebaseFirestoreUserService.updateUser(
          userId: userId,
          daysOfReading: updatedDays,
        ),
      ).called(1);
    },
  );
}
