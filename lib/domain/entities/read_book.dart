import 'package:equatable/equatable.dart';

class ReadBook extends Equatable {
  final String bookId;
  final int readPagesAmount;

  const ReadBook({
    required this.bookId,
    required this.readPagesAmount,
  });

  @override
  List<Object> get props => [
        bookId,
        readPagesAmount,
      ];

  ReadBook copyWith({
    String? bookId,
    int? readPagesAmount,
  }) {
    return ReadBook(
      bookId: bookId ?? this.bookId,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
    );
  }
}

ReadBook createReadBook({
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return ReadBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
