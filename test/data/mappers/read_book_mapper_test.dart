import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_read_book.dart';
import 'package:app/data/mappers/read_book_mapper.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const String date = '20-09-2022';
  const String bookId = 'b1';
  const int readPagesAmount = 50;
  const ReadBook entity = ReadBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
  const DbReadBook dbModel = DbReadBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
  const SqliteReadBook sqliteModel = SqliteReadBook(
    userId: userId,
    date: date,
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
  const FirebaseReadBook firebaseModel = FirebaseReadBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );

  test(
    'map from entity to db model',
    () {
      final DbReadBook mappedDbModel =
          ReadBookMapper.mapFromEntityToDbModel(entity);

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to entity',
    () {
      final ReadBook mappedModel =
          ReadBookMapper.mapFromDbModelToEntity(dbModel);

      expect(mappedModel, entity);
    },
  );

  test(
    'map from db model to sqlite model',
    () {
      final SqliteReadBook mappedSqliteModel =
          ReadBookMapper.mapFromDbModelToSqliteModel(
        dbReadBook: dbModel,
        userId: userId,
        date: date,
      );

      expect(mappedSqliteModel, sqliteModel);
    },
  );

  test(
    'map from sqlite model to db model',
    () {
      final DbReadBook mappedDbModel =
          ReadBookMapper.mapFromSqliteModelToDbModel(sqliteModel);

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to firebase model',
    () {
      final FirebaseReadBook mappedFirebaseModel =
          ReadBookMapper.mapFromDbModelToFirebaseModel(dbModel);

      expect(mappedFirebaseModel, firebaseModel);
    },
  );

  test(
    'map from firebase model to db model',
    () {
      final DbReadBook mappedDbModel =
          ReadBookMapper.mapFromFirebaseModelToDbModel(firebaseModel);

      expect(mappedDbModel, dbModel);
    },
  );
}
