import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_day_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day_book.dart';
import 'package:app/data/mappers/day_book_mapper.dart';
import 'package:app/data/models/db_day_book.dart';
import 'package:app/domain/entities/day_book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const String date = '20-09-2022';
  const String bookId = 'b1';
  const int readPagesAmount = 50;
  const DayBook entity = DayBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
  const DbDayBook dbModel = DbDayBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
  const SqliteDayBook sqliteModel = SqliteDayBook(
    userId: userId,
    date: date,
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
  const FirebaseDayBook firebaseModel = FirebaseDayBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );

  test(
    'map from entity to db model',
    () {
      final DbDayBook mappedDbModel = DayBookMapper.mapFromEntityToDbModel(
        entity,
      );

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to entity',
    () {
      final DayBook mappedModel = DayBookMapper.mapFromDbModelToEntity(dbModel);

      expect(mappedModel, entity);
    },
  );

  test(
    'map from db model to sqlite model',
    () {
      final SqliteDayBook mappedSqliteModel =
          DayBookMapper.mapFromDbModelToSqliteModel(
        dbDayBook: dbModel,
        userId: userId,
        date: date,
      );

      expect(mappedSqliteModel, sqliteModel);
    },
  );

  test(
    'map from sqlite model to db model',
    () {
      final DbDayBook mappedDbModel = DayBookMapper.mapFromSqliteModelToDbModel(
        sqliteModel,
      );

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to firebase model',
    () {
      final FirebaseDayBook mappedFirebaseModel =
          DayBookMapper.mapFromDbModelToFirebaseModel(dbModel);

      expect(mappedFirebaseModel, firebaseModel);
    },
  );

  test(
    'map from firebase model to db model',
    () {
      final DbDayBook mappedDbModel =
          DayBookMapper.mapFromFirebaseModelToDbModel(firebaseModel);

      expect(mappedDbModel, dbModel);
    },
  );
}
