import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day_book.dart';
import 'package:equatable/equatable.dart';

class FirebaseDay extends Equatable {
  final String date;
  final List<FirebaseDayBook> booksWithReadPages;

  const FirebaseDay({
    required this.date,
    required this.booksWithReadPages,
  });

  @override
  List<Object> get props => [
        date,
        booksWithReadPages,
      ];

  FirebaseDay.fromJson(Map<String, Object?> json)
      : this(
          date: json[FirebaseDayFields.date] as String,
          booksWithReadPages:
              (json[FirebaseDayFields.booksWithReadPages] as List)
                  .map((dayBookJson) => FirebaseDayBook.fromJson(dayBookJson))
                  .toList(),
        );

  Map<String, Object?> toJson() => {
        FirebaseDayFields.date: date,
        FirebaseDayFields.booksWithReadPages: booksWithReadPages.map(
          (FirebaseDayBook dayBook) => dayBook.toJson(),
        ),
      };
}

class FirebaseDayFields {
  static const String date = 'date';
  static const String booksWithReadPages = 'booksWithReadPages';
}

FirebaseDay createFirebaseDay({
  String date = '',
  List<FirebaseDayBook> booksWithReadPages = const [],
}) {
  return FirebaseDay(
    date: date,
    booksWithReadPages: booksWithReadPages,
  );
}
