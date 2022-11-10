import 'package:equatable/equatable.dart';

class FirebaseBook extends Equatable {
  final String id;
  final String userId;
  final String status;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;
  final String? imageFileName;

  const FirebaseBook({
    required this.id,
    required this.userId,
    required this.status,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
    required this.imageFileName,
  });

  FirebaseBook.fromJson({
    required Map<String, Object?> json,
    required String userId,
    required String bookId,
  }) : this(
          id: bookId,
          userId: userId,
          status: json[FirebaseBookFields.status] as String,
          title: json[FirebaseBookFields.title] as String,
          author: json[FirebaseBookFields.author] as String,
          readPagesAmount: json[FirebaseBookFields.readPagesAmount] as int,
          allPagesAmount: json[FirebaseBookFields.allPagesAmount] as int,
          imageFileName: json[FirebaseBookFields.imageFileName] as String?,
        );

  @override
  List<Object> get props => [
        id,
        userId,
        status,
        title,
        author,
        readPagesAmount,
        allPagesAmount,
        imageFileName ?? '',
      ];

  Map<String, Object?> toJson() => {
        FirebaseBookFields.status: status,
        FirebaseBookFields.title: title,
        FirebaseBookFields.author: author,
        FirebaseBookFields.readPagesAmount: readPagesAmount,
        FirebaseBookFields.allPagesAmount: allPagesAmount,
        FirebaseBookFields.imageFileName: imageFileName,
      };

  FirebaseBook copyWith({
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    String? imageFileName,
    bool deletedImageFileName = false,
  }) {
    return FirebaseBook(
      id: id,
      userId: userId,
      status: status ?? this.status,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
      imageFileName:
          deletedImageFileName ? null : imageFileName ?? this.imageFileName,
    );
  }
}

class FirebaseBookFields {
  static const String status = 'status';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
  static const String imageFileName = 'imageFileName';
}

FirebaseBook createFirebaseBook({
  String id = '',
  String userId = '',
  String status = 'unread',
  String title = '',
  String author = '',
  int readPagesAmount = 0,
  int allPagesAmount = 0,
  String? imageFileName,
}) {
  return FirebaseBook(
    id: id,
    userId: userId,
    status: status,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
    imageFileName: imageFileName,
  );
}
