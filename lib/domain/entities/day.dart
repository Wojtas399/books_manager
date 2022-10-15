import 'package:app/domain/entities/read_book.dart';
import 'package:app/models/entity.dart';

class Day extends Entity {
  final String userId;
  final DateTime date;
  final List<ReadBook> readBooks;

  const Day({
    required this.userId,
    required this.date,
    required this.readBooks,
  }) : super(id: '$userId-$date');

  @override
  List<Object> get props => [
        id,
        userId,
        date,
        readBooks,
      ];

  Day copyWith({
    String? userId,
    DateTime? date,
    List<ReadBook>? readBooks,
  }) {
    return Day(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      readBooks: readBooks ?? this.readBooks,
    );
  }
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
