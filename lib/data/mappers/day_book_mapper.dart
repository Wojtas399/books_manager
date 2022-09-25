import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day_book.dart';
import 'package:app/data/models/db_day_book.dart';
import 'package:app/domain/entities/day_book.dart';

class DayBookMapper {
  static DbDayBook mapFromEntityToDbModel(DayBook dayBook) {
    return DbDayBook(
      bookId: dayBook.bookId,
      readPagesAmount: dayBook.readPagesAmount,
    );
  }

  static DayBook mapFromDbModelToEntity(DbDayBook dbDayBook) {
    return DayBook(
      bookId: dbDayBook.bookId,
      readPagesAmount: dbDayBook.readPagesAmount,
    );
  }

  static SqliteReadPages mapFromDbModelToSqliteModel({
    required DbDayBook dbDayBook,
    required String userId,
    required String date,
  }) {
    return SqliteReadPages(
      userId: userId,
      date: date,
      bookId: dbDayBook.bookId,
      readPagesAmount: dbDayBook.readPagesAmount,
    );
  }

  static DbDayBook mapFromSqliteModelToDbModel(
    SqliteReadPages sqliteReadPages,
  ) {
    return DbDayBook(
      bookId: sqliteReadPages.bookId,
      readPagesAmount: sqliteReadPages.readPagesAmount,
    );
  }

  static FirebaseDayBook mapFromDbModelToFirebaseModel(DbDayBook dbDayBook) {
    return FirebaseDayBook(
      bookId: dbDayBook.bookId,
      readPagesAmount: dbDayBook.readPagesAmount,
    );
  }

  static DbDayBook mapFromFirebaseModelToDbModel(
    FirebaseDayBook firebaseDayBook,
  ) {
    return DbDayBook(
      bookId: firebaseDayBook.bookId,
      readPagesAmount: firebaseDayBook.readPagesAmount,
    );
  }
}
