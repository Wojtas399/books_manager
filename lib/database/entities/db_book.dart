import 'package:equatable/equatable.dart';

class DbBook extends Equatable {
  final String? id;
  final String userId;
  final String status;
  final String? image;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const DbBook({
    this.id,
    required this.userId,
    required this.status,
    required this.image,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        id ?? '',
        userId,
        status,
        image ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  DbBook.fromSqliteJson(Map<String, Object?> json)
      : this(
          id: json[DatabaseBookFields.id] as String?,
          userId: json[DatabaseBookFields.userId] as String,
          status: json[DatabaseBookFields.status] as String,
          image: json[DatabaseBookFields.image] as String?,
          title: json[DatabaseBookFields.title] as String,
          author: json[DatabaseBookFields.author] as String,
          readPagesAmount: json[DatabaseBookFields.readPagesAmount] as int,
          allPagesAmount: json[DatabaseBookFields.allPagesAmount] as int,
        );

  DbBook.fromFirebaseJson(
    Map<String, Object?> json,
    String bookId,
    String userId,
  ) : this(
          id: bookId,
          userId: userId,
          status: json[DatabaseBookFields.status] as String,
          image: json[DatabaseBookFields.image] as String?,
          title: json[DatabaseBookFields.title] as String,
          author: json[DatabaseBookFields.author] as String,
          readPagesAmount: json[DatabaseBookFields.readPagesAmount] as int,
          allPagesAmount: json[DatabaseBookFields.allPagesAmount] as int,
        );

  Map<String, Object?> toSqliteJson() => {
        DatabaseBookFields.id: id,
        DatabaseBookFields.userId: userId,
        DatabaseBookFields.status: status,
        DatabaseBookFields.image: image,
        DatabaseBookFields.title: title,
        DatabaseBookFields.author: author,
        DatabaseBookFields.readPagesAmount: readPagesAmount,
        DatabaseBookFields.allPagesAmount: allPagesAmount,
      };

  Map<String, Object?> toFirebaseJson() => {
        DatabaseBookFields.status: status,
        DatabaseBookFields.image: image,
        DatabaseBookFields.title: title,
        DatabaseBookFields.author: author,
        DatabaseBookFields.readPagesAmount: readPagesAmount,
        DatabaseBookFields.allPagesAmount: allPagesAmount,
      };

  DbBook copyWith({
    String? id,
    String? status,
    String? image,
    String? userId,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) {
    return DbBook(
      id: id ?? this.id,
      status: status ?? this.status,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }
}

class DatabaseBookFields {
  static const String id = '_id';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String image = 'image';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
}

DbBook createDbBook(
    {String? id,
    String userId = '',
    String status = 'unread',
    String? image,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0}) {
  return DbBook(
    id: id,
    userId: userId,
    status: status,
    image: image,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
  );
}
