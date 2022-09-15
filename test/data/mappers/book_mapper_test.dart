import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:app/data/mappers/book_mapper.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String bookId = 'b1';
  final Uint8List imageData = Uint8List(10);
  const String userId = 'u1';
  const BookStatus status = BookStatus.inProgress;
  const String title = 'title';
  const String author = 'author';
  const int readPagesAmount = 100;
  const int allPagesAmount = 300;
  const SyncState syncState = SyncState.added;
  final Book entity = Book(
    id: bookId,
    userId: userId,
    status: status,
    imageData: imageData,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
  );
  final DbBook dbModel = DbBook(
    id: bookId,
    userId: userId,
    status: status.name,
    imageData: imageData,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
  );
  final SqliteBook sqliteModel = createSqliteBook(
    id: bookId,
    userId: userId,
    status: status.name,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
    syncState: syncState,
  );
  final FirebaseBook firebaseModel = createFirebaseBook(
    id: bookId,
    userId: userId,
    status: status.name,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
  );

  test(
    'map from db model to entity',
    () {
      final Book mappedEntity = BookMapper.mapFromDbModelToEntity(dbModel);

      expect(mappedEntity, entity);
    },
  );

  test(
    'map from entity to db model',
    () {
      final DbBook mappedDbModel = BookMapper.mapFromEntityToDbModel(entity);

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to sqlite model',
    () {
      final SqliteBook mappedSqliteModel =
          BookMapper.mapFromDbModelToSqliteModel(dbModel, syncState);

      expect(mappedSqliteModel, sqliteModel);
    },
  );

  test(
    'map from sqlite model to db model',
    () {
      final DbBook mappedDbModel = BookMapper.mapFromSqliteModelToDbModel(
        sqliteModel,
        imageData,
      );

      expect(mappedDbModel, dbModel);
    },
  );

  test(
    'map from db model to firebase model',
    () {
      final FirebaseBook mappedFirebaseModel =
          BookMapper.mapFromDbModelToFirebaseModel(dbModel);

      expect(mappedFirebaseModel, firebaseModel);
    },
  );

  test(
    'map from firebase model to db model',
    () {
      final DbBook mappedDbModel = BookMapper.mapFromFirebaseModelToDbModel(
        firebaseModel,
        imageData,
      );

      expect(mappedDbModel, dbModel);
    },
  );
}
