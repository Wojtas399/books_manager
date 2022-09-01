import 'dart:typed_data';

import 'package:app/data/mappers/book_mapper.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String bookId = 'b1';
  final Uint8List imageData = Uint8List(10);
  const String userId = 'u1';
  const String title = 'title';
  const String author = 'author';
  const int readPagesAmount = 100;
  const int allPagesAmount = 300;
  final DbBook dbModel = DbBook(
    id: bookId,
    userId: userId,
    status: BookStatus.inProgress.name,
    imageData: imageData,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
  );
  final Book entity = Book(
    id: bookId,
    userId: userId,
    status: BookStatus.inProgress,
    imageData: imageData,
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
}
