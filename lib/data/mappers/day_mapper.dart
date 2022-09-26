import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/read_book_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:app/domain/entities/day.dart';

class DayMapper {
  static DbDay mapFromEntityToDbModel(Day day) {
    return DbDay(
      userId: day.userId,
      date: DateMapper.mapFromDateTimeToString(day.date),
      readBooks:
          day.readBooks.map(ReadBookMapper.mapFromEntityToDbModel).toList(),
    );
  }

  static Day mapFromDbModelToEntity(DbDay dbDay) {
    return Day(
      userId: dbDay.userId,
      date: DateMapper.mapFromStringToDateTime(dbDay.date),
      readBooks:
          dbDay.readBooks.map(ReadBookMapper.mapFromDbModelToEntity).toList(),
    );
  }

  static List<SqliteReadBook> mapFromDbModelToSqliteModels({
    required DbDay dbDay,
    required String userId,
  }) {
    return dbDay.readBooks
        .map(
          (DbReadBook dbReadBook) => ReadBookMapper.mapFromDbModelToSqliteModel(
            dbReadBook: dbReadBook,
            userId: userId,
            date: dbDay.date,
          ),
        )
        .toList();
  }

  static DbDay mapFromSqliteModelsToDbModel(List<SqliteReadBook> sqliteModels) {
    return DbDay(
      userId: sqliteModels.first.userId,
      date: sqliteModels.first.date,
      readBooks:
          sqliteModels.map(ReadBookMapper.mapFromSqliteModelToDbModel).toList(),
    );
  }

  static DbDay mapFromFirebaseModelToDbModel(FirebaseDay firebaseDay) {
    return DbDay(
      userId: firebaseDay.userId,
      date: firebaseDay.date,
      readBooks: firebaseDay.readBooks
          .map(ReadBookMapper.mapFromFirebaseModelToDbModel)
          .toList(),
    );
  }

  static FirebaseDay mapFromDbModelToFirebaseModel(DbDay dbDay) {
    return FirebaseDay(
      userId: dbDay.userId,
      date: dbDay.date,
      readBooks: dbDay.readBooks
          .map(ReadBookMapper.mapFromDbModelToFirebaseModel)
          .toList(),
    );
  }
}
