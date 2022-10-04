import 'package:equatable/equatable.dart';

class DbReadBook extends Equatable {
  final String bookId;
  final int readPagesAmount;

  const DbReadBook({
    required this.bookId,
    required this.readPagesAmount,
  });

  @override
  List<Object> get props => [
        bookId,
        readPagesAmount,
      ];
}

DbReadBook createDbReadBook({
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return DbReadBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
