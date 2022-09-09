import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/domain/entities/book.dart';

class BookMapper {
  static DbBook mapFromEntityToDbModel(Book book) {
    return DbBook(
      id: book.id,
      imageData: book.imageData,
      userId: book.userId,
      status: BookStatusMapper.mapFromEnumToString(book.status),
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    );
  }

  static Book mapFromDbModelToEntity(DbBook dbBook) {
    return Book(
      id: dbBook.id,
      userId: dbBook.userId,
      status: BookStatusMapper.mapFromStringToEnum(dbBook.status),
      imageData: dbBook.imageData,
      title: dbBook.title,
      author: dbBook.author,
      readPagesAmount: dbBook.readPagesAmount,
      allPagesAmount: dbBook.allPagesAmount,
    );
  }

  static SqliteBook mapFromDbModelToSqliteModel(
    DbBook dbBook,
    SyncState syncState,
  ) {
    return SqliteBook(
      id: dbBook.id,
      userId: dbBook.userId,
      status: dbBook.status,
      title: dbBook.title,
      author: dbBook.author,
      readPagesAmount: dbBook.readPagesAmount,
      allPagesAmount: dbBook.allPagesAmount,
      syncState: syncState,
    );
  }

  static DbBook mapFromSqliteModelToDbModel(
    SqliteBook sqliteBook,
    Uint8List? imageData,
  ) {
    return DbBook(
      id: sqliteBook.id,
      imageData: imageData,
      userId: sqliteBook.userId,
      status: sqliteBook.status,
      title: sqliteBook.title,
      author: sqliteBook.author,
      readPagesAmount: sqliteBook.readPagesAmount,
      allPagesAmount: sqliteBook.allPagesAmount,
    );
  }

  static FirebaseBook mapFromDbModelToFirebaseModel(DbBook dbBook) {
    return FirebaseBook(
      id: dbBook.id,
      userId: dbBook.userId,
      status: dbBook.status,
      title: dbBook.title,
      author: dbBook.author,
      readPagesAmount: dbBook.readPagesAmount,
      allPagesAmount: dbBook.allPagesAmount,
    );
  }

  static DbBook mapFromFirebaseModelToDbModel(
    FirebaseBook firebaseBook,
    Uint8List? imageData,
  ) {
    return DbBook(
      id: firebaseBook.id,
      imageData: imageData,
      userId: firebaseBook.userId,
      status: firebaseBook.status,
      title: firebaseBook.title,
      author: firebaseBook.author,
      readPagesAmount: firebaseBook.readPagesAmount,
      allPagesAmount: firebaseBook.allPagesAmount,
    );
  }
}
