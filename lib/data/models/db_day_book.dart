import 'package:equatable/equatable.dart';

class DbDayBook extends Equatable {
  final String bookId;
  final int readPagesAmount;

  const DbDayBook({
    required this.bookId,
    required this.readPagesAmount,
  });

  @override
  List<Object> get props => [
        bookId,
        readPagesAmount,
      ];
}

DbDayBook createDbDayBook({
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return DbDayBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
