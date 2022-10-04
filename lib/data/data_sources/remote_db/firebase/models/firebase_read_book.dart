import 'package:equatable/equatable.dart';

class FirebaseReadBook extends Equatable {
  final String bookId;
  final int readPagesAmount;

  const FirebaseReadBook({
    required this.bookId,
    required this.readPagesAmount,
  });

  @override
  List<Object> get props => [
        bookId,
        readPagesAmount,
      ];

  FirebaseReadBook.fromJson(Map<String, Object?> json)
      : this(
          bookId: json[FirebaseReadBookFields.bookId] as String,
          readPagesAmount: json[FirebaseReadBookFields.readPagesAmount] as int,
        );

  Map<String, Object?> toJson() => {
        FirebaseReadBookFields.bookId: bookId,
        FirebaseReadBookFields.readPagesAmount: readPagesAmount,
      };

  FirebaseReadBook copyWith({
    String? bookId,
    int? readPagesAmount,
  }) {
    return FirebaseReadBook(
      bookId: bookId ?? this.bookId,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
    );
  }
}

class FirebaseReadBookFields {
  static const String bookId = 'bookId';
  static const String readPagesAmount = 'readPagesAmount';
}

FirebaseReadBook createFirebaseReadBook({
  String bookId = '',
  int readPagesAmount = 0,
}) {
  return FirebaseReadBook(
    bookId: bookId,
    readPagesAmount: readPagesAmount,
  );
}
