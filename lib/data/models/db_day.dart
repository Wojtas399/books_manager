import 'package:app/data/models/db_read_book.dart';
import 'package:equatable/equatable.dart';

class DbDay extends Equatable {
  final String userId;
  final String date;
  final List<DbReadBook> readBooks;

  const DbDay({
    required this.userId,
    required this.date,
    required this.readBooks,
  });

  @override
  List<Object> get props => [
        userId,
        date,
        readBooks,
      ];

  DbDay copyWith({
    String? userId,
    String? date,
    List<DbReadBook>? readBooks,
  }) {
    return DbDay(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      readBooks: readBooks ?? this.readBooks,
    );
  }
}

DbDay createDbDay({
  String userId = '',
  String date = '',
  List<DbReadBook> readBooks = const [],
}) {
  return DbDay(
    userId: userId,
    date: date,
    readBooks: readBooks,
  );
}
