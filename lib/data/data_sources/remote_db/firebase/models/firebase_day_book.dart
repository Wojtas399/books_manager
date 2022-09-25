import 'package:equatable/equatable.dart';

class FirebaseDayBook extends Equatable {
  final String bookId;
  final int readPagesAmount;

  const FirebaseDayBook({
    required this.bookId,
    required this.readPagesAmount,
  });

  @override
  List<Object> get props => [
        bookId,
        readPagesAmount,
      ];

  FirebaseDayBook.fromJson(Map<String, Object?> json)
      : this(
          bookId: json[FirebaseDayBookFields.bookId] as String,
          readPagesAmount: json[FirebaseDayBookFields.readPagesAmount] as int,
        );

  Map<String, Object?> toJson() => {
        FirebaseDayBookFields.bookId: bookId,
        FirebaseDayBookFields.readPagesAmount: readPagesAmount,
      };

  FirebaseDayBook copyWith({
    String? bookId,
    int? readPagesAmount,
  }) {
    return FirebaseDayBook(
      bookId: bookId ?? this.bookId,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
    );
  }
}

class FirebaseDayBookFields {
  static const String bookId = 'bookId';
  static const String readPagesAmount = 'readPagesAmount';
}

FirebaseDayBook createFirebaseDayBook({
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return FirebaseDayBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
