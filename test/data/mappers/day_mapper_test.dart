import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day_book.dart';
import 'package:app/data/mappers/day_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_day_book.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/day_book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const String date = '22-09-2022';
  final Day entity = createDay(
    userId: userId,
    date: DateTime(2022, 9, 22),
    booksWithReadPagesAmount: [
      createDayBook(
        bookId: 'b1',
        readPagesAmount: 20,
      ),
      createDayBook(
        bookId: 'b2',
        readPagesAmount: 100,
      ),
    ],
  );
  final DbDay dbModel = createDbDay(
    userId: userId,
    date: date,
    booksWithReadPages: [
      createDbDayBook(
        bookId: 'b1',
        readPagesAmount: 20,
      ),
      createDbDayBook(
        bookId: 'b2',
        readPagesAmount: 100,
      ),
    ],
  );
  final List<SqliteReadPages> sqliteReadPagesModels = [
    createSqliteReadPages(
      userId: userId,
      date: '22-09-2022',
      bookId: 'b1',
      readPagesAmount: 20,
    ),
    createSqliteReadPages(
      userId: userId,
      date: '22-09-2022',
      bookId: 'b2',
      readPagesAmount: 100,
    ),
  ];
  final FirebaseDay firebaseModel = createFirebaseDay(
    userId: userId,
    date: date,
    booksWithReadPages: [
      createFirebaseDayBook(
        bookId: 'b1',
        readPagesAmount: 20,
      ),
      createFirebaseDayBook(
        bookId: 'b2',
        readPagesAmount: 100,
      ),
    ],
  );

  test(
    'map from entity to db model',
    () {
      final DbDay mappedDbModel = DayMapper.mapFromEntityToDbModel(entity);

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to entity',
    () {
      final Day mappedEntity = DayMapper.mapFromDbModelToEntity(dbModel);

      expect(mappedEntity, entity);
    },
  );

  test(
    'map from db model to list of sqlite models',
    () {
      final List<SqliteReadPages> mappedSqliteReadPagesModels =
          DayMapper.mapFromDbModelToListOfSqliteModels(
        dbDay: dbModel,
        userId: userId,
      );

      expect(mappedSqliteReadPagesModels, sqliteReadPagesModels);
    },
  );

  test(
    'map from list of sqlite models to db model',
    () {
      final DbDay mappedDbModel = DayMapper.mapFromListOfSqliteModelToDbModel(
        sqliteReadPagesModels,
      );

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from firebase model to db model',
    () {
      final DbDay mappedDbModel = DayMapper.mapFromFirebaseModelToDbModel(
        firebaseModel,
      );

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to firebase model',
    () {
      final FirebaseDay mappedFirebaseModel =
          DayMapper.mapFromDbModelToFirebaseModel(dbModel);

      expect(mappedFirebaseModel, firebaseModel);
    },
  );
}
