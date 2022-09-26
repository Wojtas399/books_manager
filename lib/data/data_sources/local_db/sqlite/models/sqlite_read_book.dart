import 'package:equatable/equatable.dart';

class SqliteReadBook extends Equatable {
  final String userId;
  final String date;
  final String bookId;
  final int readPagesAmount;

  const SqliteReadBook({
    required this.userId,
    required this.date,
    required this.bookId,
    required this.readPagesAmount,
  });

  SqliteReadBook.fromJson(Map<String, Object?> json)
      : this(
          userId: json[SqliteReadBookFields.userId] as String,
          date: json[SqliteReadBookFields.date] as String,
          bookId: json[SqliteReadBookFields.bookId] as String,
          readPagesAmount: json[SqliteReadBookFields.readPagesAmount] as int,
        );

  @override
  List<Object> get props => [
        userId,
        date,
        bookId,
        readPagesAmount,
      ];

  Map<String, Object?> toJson() => {
        SqliteReadBookFields.userId: userId,
        SqliteReadBookFields.date: date,
        SqliteReadBookFields.bookId: bookId,
        SqliteReadBookFields.readPagesAmount: readPagesAmount,
      };

  SqliteReadBook copyWithReadPagesAmount(int? newReadPagesAmount) {
    return SqliteReadBook(
      userId: userId,
      date: date,
      bookId: bookId,
      readPagesAmount: newReadPagesAmount ?? readPagesAmount,
    );
  }
}

class SqliteReadBookFields {
  static const String userId = 'userId';
  static const String date = 'date';
  static const String bookId = 'bookId';
  static const String readPagesAmount = 'readPagesAmount';
}

SqliteReadBook createSqliteReadBook({
  String userId = '',
  String date = '',
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return SqliteReadBook(
    userId: userId,
    date: date,
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
