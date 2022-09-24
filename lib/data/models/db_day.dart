import 'package:app/data/models/db_day_book.dart';
import 'package:equatable/equatable.dart';

class DbDay extends Equatable {
  final String date;
  final List<DbDayBook> booksWithReadPages;

  const DbDay({
    required this.date,
    required this.booksWithReadPages,
  });

  @override
  List<Object> get props => [
        date,
        booksWithReadPages,
      ];
}

DbDay createDbDay({
  String date = '',
  List<DbDayBook> booksWithReadPages = const [],
}) {
  return DbDay(
    date: date,
    booksWithReadPages: booksWithReadPages,
  );
}
