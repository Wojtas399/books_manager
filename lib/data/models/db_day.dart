import 'package:app/data/models/db_day_book.dart';
import 'package:equatable/equatable.dart';

class DbDay extends Equatable {
  final String userId;
  final String date;
  final List<DbDayBook> booksWithReadPages;

  const DbDay({
    required this.userId,
    required this.date,
    required this.booksWithReadPages,
  });

  @override
  List<Object> get props => [
        userId,
        date,
        booksWithReadPages,
      ];

  DbDay copyWith({
    String? userId,
    String? date,
    List<DbDayBook>? booksWithReadPages,
  }) {
    return DbDay(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      booksWithReadPages: booksWithReadPages ?? this.booksWithReadPages,
    );
  }
}

DbDay createDbDay({
  String userId = '',
  String date = '',
  List<DbDayBook> booksWithReadPages = const [],
}) {
  return DbDay(
    userId: userId,
    date: date,
    booksWithReadPages: booksWithReadPages,
  );
}
