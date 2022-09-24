import 'package:equatable/equatable.dart';

class DayBook extends Equatable {
  final String bookId;
  final int readPagesAmount;

  const DayBook({
    required this.bookId,
    required this.readPagesAmount,
  });

  @override
  List<Object> get props => [
        bookId,
        readPagesAmount,
      ];
}

DayBook createDayBook({
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return DayBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
