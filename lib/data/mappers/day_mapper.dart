import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/day_book_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_day_book.dart';
import 'package:app/domain/entities/day.dart';

class DayMapper {
  static DbDay mapFromEntityToDbModel(Day day) {
    return DbDay(
      userId: day.userId,
      date: DateMapper.mapFromDateTimeToString(day.date),
      booksWithReadPages: day.booksWithReadPagesAmount
          .map(DayBookMapper.mapFromEntityToDbModel)
          .toList(),
    );
  }

  static Day mapFromDbModelToEntity(DbDay dbDay) {
    return Day(
      userId: dbDay.userId,
      date: DateMapper.mapFromStringToDateTime(dbDay.date),
      booksWithReadPagesAmount: dbDay.booksWithReadPages
          .map(DayBookMapper.mapFromDbModelToEntity)
          .toList(),
    );
  }

  static List<SqliteReadPages> mapFromDbModelToListOfSqliteModels({
    required DbDay dbDay,
    required String userId,
  }) {
    return dbDay.booksWithReadPages
        .map(
          (DbDayBook dbDayBook) => DayBookMapper.mapFromDbModelToSqliteModel(
            dbDayBook: dbDayBook,
            userId: userId,
            date: dbDay.date,
          ),
        )
        .toList();
  }

  static DbDay mapFromListOfSqliteModelsToDbModel(
    List<SqliteReadPages> listOfSqliteDayBook,
  ) {
    return DbDay(
      userId: listOfSqliteDayBook.first.userId,
      date: listOfSqliteDayBook.first.date,
      booksWithReadPages: listOfSqliteDayBook
          .map(DayBookMapper.mapFromSqliteModelToDbModel)
          .toList(),
    );
  }

  static DbDay mapFromFirebaseModelToDbModel(FirebaseDay firebaseDay) {
    return DbDay(
      userId: firebaseDay.userId,
      date: firebaseDay.date,
      booksWithReadPages: firebaseDay.booksWithReadPages
          .map(DayBookMapper.mapFromFirebaseModelToDbModel)
          .toList(),
    );
  }

  static FirebaseDay mapFromDbModelToFirebaseModel(DbDay dbDay) {
    return FirebaseDay(
      userId: dbDay.userId,
      date: dbDay.date,
      booksWithReadPages: dbDay.booksWithReadPages
          .map(DayBookMapper.mapFromDbModelToFirebaseModel)
          .toList(),
    );
  }
}
