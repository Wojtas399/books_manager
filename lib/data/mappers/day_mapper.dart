import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_day_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/day_book_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_day_book.dart';
import 'package:app/domain/entities/day.dart';

class DayMapper {
  static DbDay mapFromEntityToDbModel(Day day) {
    return DbDay(
      date: DateMapper.mapFromDateTimeToString(day.date),
      booksWithReadPages: day.booksWithReadPagesAmount
          .map(DayBookMapper.mapFromEntityToDbModel)
          .toList(),
    );
  }

  static Day mapFromDbModelToEntity(DbDay dbDay) {
    return Day(
      date: DateMapper.mapFromStringToDateTime(dbDay.date),
      booksWithReadPagesAmount: dbDay.booksWithReadPages
          .map(DayBookMapper.mapFromDbModelToEntity)
          .toList(),
    );
  }

  static List<SqliteDayBook> mapFromDbModelToListOfSqliteModels({
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

  static DbDay mapFromListOfSqliteModelToDbModel(
    List<SqliteDayBook> listOfSqliteDayBook,
  ) {
    return DbDay(
      date: listOfSqliteDayBook.first.date,
      booksWithReadPages: listOfSqliteDayBook
          .map(DayBookMapper.mapFromSqliteModelToDbModel)
          .toList(),
    );
  }

  static DbDay mapFromFirebaseModelToDbModel(FirebaseDay firebaseDay) {
    return DbDay(
      date: firebaseDay.date,
      booksWithReadPages: firebaseDay.booksWithReadPages
          .map(DayBookMapper.mapFromFirebaseModelToDbModel)
          .toList(),
    );
  }

  static FirebaseDay mapFromDbModelToFirebaseModel(DbDay dbDay) {
    return FirebaseDay(
      date: dbDay.date,
      booksWithReadPages: dbDay.booksWithReadPages
          .map(DayBookMapper.mapFromDbModelToFirebaseModel)
          .toList(),
    );
  }
}
