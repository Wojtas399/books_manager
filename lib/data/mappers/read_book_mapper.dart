import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_read_book.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/domain/entities/read_book.dart';

class ReadBookMapper {
  static DbReadBook mapFromEntityToDbModel(ReadBook readBook) {
    return DbReadBook(
      bookId: readBook.bookId,
      readPagesAmount: readBook.readPagesAmount,
    );
  }

  static ReadBook mapFromDbModelToEntity(DbReadBook dbReadBook) {
    return ReadBook(
      bookId: dbReadBook.bookId,
      readPagesAmount: dbReadBook.readPagesAmount,
    );
  }

  static SqliteReadBook mapFromDbModelToSqliteModel({
    required DbReadBook dbReadBook,
    required String userId,
    required String date,
    SyncState syncState = SyncState.none,
  }) {
    return SqliteReadBook(
      userId: userId,
      date: date,
      bookId: dbReadBook.bookId,
      readPagesAmount: dbReadBook.readPagesAmount,
      syncState: syncState,
    );
  }

  static DbReadBook mapFromSqliteModelToDbModel(
    SqliteReadBook sqliteReadBook,
  ) {
    return DbReadBook(
      bookId: sqliteReadBook.bookId,
      readPagesAmount: sqliteReadBook.readPagesAmount,
    );
  }

  static FirebaseReadBook mapFromDbModelToFirebaseModel(DbReadBook dbReadBook) {
    return FirebaseReadBook(
      bookId: dbReadBook.bookId,
      readPagesAmount: dbReadBook.readPagesAmount,
    );
  }

  static DbReadBook mapFromFirebaseModelToDbModel(
    FirebaseReadBook firebaseReadBook,
  ) {
    return DbReadBook(
      bookId: firebaseReadBook.bookId,
      readPagesAmount: firebaseReadBook.readPagesAmount,
    );
  }
}
