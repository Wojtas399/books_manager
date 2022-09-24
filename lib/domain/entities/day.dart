import 'package:app/domain/entities/day_book.dart';
import 'package:equatable/equatable.dart';

class Day extends Equatable {
  final DateTime date;
  final List<DayBook> booksWithReadPagesAmount;

  const Day({
    required this.date,
    required this.booksWithReadPagesAmount,
  });

  @override
  List<Object> get props => [
        date,
        booksWithReadPagesAmount,
      ];
}

Day createDay({
  DateTime? date,
  List<DayBook> booksWithReadPagesAmount = const [],
}) {
  return Day(
    date: date ?? DateTime(2022),
    booksWithReadPagesAmount: booksWithReadPagesAmount,
  );
}
