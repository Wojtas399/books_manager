import 'package:app/data/models/db_book.dart';

class FirebaseBook extends DbBook {
  const FirebaseBook({
    super.id,
    super.imageData,
    required super.userId,
    required super.status,
    required super.title,
    required super.author,
    required super.readPagesAmount,
    required super.allPagesAmount,
  });

  FirebaseBook.fromJson({
    required Map<String, Object?> json,
    required String userId,
    required String bookId,
  }) : this(
          id: bookId,
          imageData: null,
          userId: userId,
          status: json[FirebaseBookFields.status] as String,
          title: json[FirebaseBookFields.title] as String,
          author: json[FirebaseBookFields.author] as String,
          readPagesAmount: json[FirebaseBookFields.readPagesAmount] as int,
          allPagesAmount: json[FirebaseBookFields.allPagesAmount] as int,
        );

  Map<String, Object?> toJson() => {
        FirebaseBookFields.status: status,
        FirebaseBookFields.title: title,
        FirebaseBookFields.author: author,
        FirebaseBookFields.readPagesAmount: readPagesAmount,
        FirebaseBookFields.allPagesAmount: allPagesAmount,
      };

  DbBook toDbBook() => DbBook(
        userId: userId,
        status: status,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );
}

class FirebaseBookFields {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
}

extension FirebaseDbBookExtensions on DbBook {
  FirebaseBook toFirebaseBook() {
    return FirebaseBook(
      id: id,
      imageData: imageData,
      userId: userId,
      status: status,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }
}
