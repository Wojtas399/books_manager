import 'package:app/domain/entities/day_book.dart';
import 'package:equatable/equatable.dart';

class Day extends Equatable {
  final String userId;
  final DateTime date;
  final List<DayBook> booksWithReadPagesAmount;

  const Day({
    required this.userId,
    required this.date,
    required this.booksWithReadPagesAmount,
  });

  @override
  List<Object> get props => [
        userId,
        date,
        booksWithReadPagesAmount,
      ];
}

Day createDay({
  String userId = '',
  DateTime? date,
  List<DayBook> booksWithReadPagesAmount = const [],
}) {
  return Day(
    userId: userId,
    date: date ?? DateTime(2022),
    booksWithReadPagesAmount: booksWithReadPagesAmount,
  );
}
