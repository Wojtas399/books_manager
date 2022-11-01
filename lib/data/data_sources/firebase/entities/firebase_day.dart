import 'package:app/data/data_sources/firebase/entities/firebase_read_book.dart';
import 'package:equatable/equatable.dart';

class FirebaseDay extends Equatable {
  final String userId;
  final String date;
  final List<FirebaseReadBook> readBooks;

  const FirebaseDay({
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

  FirebaseDay.fromJson({
    required Map<String, Object?> json,
    required String userId,
  }) : this(
          userId: userId,
          date: json[FirebaseDayFields.date] as String,
          readBooks: (json[FirebaseDayFields.readBooks] as List)
              .map((readBookJson) => FirebaseReadBook.fromJson(readBookJson))
              .toList(),
        );

  Map<String, Object?> toJson() => {
        FirebaseDayFields.date: date,
        FirebaseDayFields.readBooks: readBooks
            .map((FirebaseReadBook readBook) => readBook.toJson())
            .toList(),
      };

  FirebaseDay copyWith({
    String? userId,
    String? date,
    List<FirebaseReadBook>? readBooks,
  }) {
    return FirebaseDay(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      readBooks: readBooks ?? this.readBooks,
    );
  }
}

class FirebaseDayFields {
  static const String date = 'date';
  static const String readBooks = 'readBooks';
}

FirebaseDay createFirebaseDay({
  String userId = '',
  String date = '',
  List<FirebaseReadBook> readBooks = const [],
}) {
  return FirebaseDay(
    userId: userId,
    date: date,
    readBooks: readBooks,
  );
}
