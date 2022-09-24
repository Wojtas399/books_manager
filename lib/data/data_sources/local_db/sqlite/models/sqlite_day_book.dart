import 'package:equatable/equatable.dart';

class SqliteDayBook extends Equatable {
  final String userId;
  final String date;
  final String bookId;
  final int readPagesAmount;

  const SqliteDayBook({
    required this.userId,
    required this.date,
    required this.bookId,
    required this.readPagesAmount,
  });

  SqliteDayBook.fromJson(Map<String, Object?> json)
      : this(
          userId: json[SqliteDayBookFields.userId] as String,
          date: json[SqliteDayBookFields.date] as String,
          bookId: json[SqliteDayBookFields.bookId] as String,
          readPagesAmount: json[SqliteDayBookFields.readPagesAmount] as int,
        );

  @override
  List<Object> get props => [
        userId,
        date,
        bookId,
        readPagesAmount,
      ];

  Map<String, Object?> toJson() => {
        SqliteDayBookFields.userId: userId,
        SqliteDayBookFields.date: date,
        SqliteDayBookFields.bookId: bookId,
        SqliteDayBookFields.readPagesAmount: readPagesAmount,
      };
}

class SqliteDayBookFields {
  static const String userId = 'userId';
  static const String date = 'date';
  static const String bookId = 'bookId';
  static const String readPagesAmount = 'readPagesAmount';
}

SqliteDayBook createSqliteDayBook({
  String userId = '',
  String date = '',
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return SqliteDayBook(
    userId: userId,
    date: date,
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
