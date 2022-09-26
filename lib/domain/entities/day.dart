import 'package:app/domain/entities/read_book.dart';
import 'package:equatable/equatable.dart';

class Day extends Equatable {
  final String userId;
  final DateTime date;
  final List<ReadBook> readBooks;

  const Day({
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
}

Day createDay({
  String userId = '',
  DateTime? date,
  List<ReadBook> readBooks = const [],
}) {
  return Day(
    userId: userId,
    date: date ?? DateTime(2022),
    readBooks: readBooks,
  );
}
