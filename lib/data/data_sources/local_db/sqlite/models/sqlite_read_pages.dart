import 'package:equatable/equatable.dart';

class SqliteReadPages extends Equatable {
  final String userId;
  final String date;
  final String bookId;
  final int readPagesAmount;

  const SqliteReadPages({
    required this.userId,
    required this.date,
    required this.bookId,
    required this.readPagesAmount,
  });

  SqliteReadPages.fromJson(Map<String, Object?> json)
      : this(
          userId: json[SqliteReadPagesFields.userId] as String,
          date: json[SqliteReadPagesFields.date] as String,
          bookId: json[SqliteReadPagesFields.bookId] as String,
          readPagesAmount: json[SqliteReadPagesFields.readPagesAmount] as int,
        );

  @override
  List<Object> get props => [
        userId,
        date,
        bookId,
        readPagesAmount,
      ];

  Map<String, Object?> toJson() => {
        SqliteReadPagesFields.userId: userId,
        SqliteReadPagesFields.date: date,
        SqliteReadPagesFields.bookId: bookId,
        SqliteReadPagesFields.readPagesAmount: readPagesAmount,
      };

  SqliteReadPages copyWithReadPagesAmount(int? newReadPagesAmount) {
    return SqliteReadPages(
      userId: userId,
      date: date,
      bookId: bookId,
      readPagesAmount: newReadPagesAmount ?? readPagesAmount,
    );
  }
}

class SqliteReadPagesFields {
  static const String userId = 'userId';
  static const String date = 'date';
  static const String bookId = 'bookId';
  static const String readPagesAmount = 'readPagesAmount';
}

SqliteReadPages createSqliteReadPages({
  String userId = '',
  String date = '',
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return SqliteReadPages(
    userId: userId,
    date: date,
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
