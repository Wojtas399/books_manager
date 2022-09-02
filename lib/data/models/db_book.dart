import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class DbBook extends Equatable {
  final String? id;
  final Uint8List? imageData;
  final String userId;
  final String status;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const DbBook({
    this.id,
    this.imageData,
    required this.userId,
    required this.status,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        id ?? '',
        imageData ?? '',
        userId,
        status,
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  DbBook.fromSqliteJson(Map<String, Object?> json)
      : this(
          id: json[DbBookFields.id] as String?,
          userId: json[DbBookFields.userId] as String,
          status: json[DbBookFields.status] as String,
          title: json[DbBookFields.title] as String,
          author: json[DbBookFields.author] as String,
          readPagesAmount: json[DbBookFields.readPagesAmount] as int,
          allPagesAmount: json[DbBookFields.allPagesAmount] as int,
        );

  DbBook.fromFirebaseJson(
    Map<String, Object?> json,
    String bookId,
    String userId,
  ) : this(
          id: bookId,
          userId: userId,
          status: json[DbBookFields.status] as String,
          title: json[DbBookFields.title] as String,
          author: json[DbBookFields.author] as String,
          readPagesAmount: json[DbBookFields.readPagesAmount] as int,
          allPagesAmount: json[DbBookFields.allPagesAmount] as int,
        );

  Map<String, Object?> toSqliteJson() => {
        DbBookFields.id: id,
        DbBookFields.userId: userId,
        DbBookFields.status: status,
        DbBookFields.title: title,
        DbBookFields.author: author,
        DbBookFields.readPagesAmount: readPagesAmount,
        DbBookFields.allPagesAmount: allPagesAmount,
      };

  Map<String, Object?> toFirebaseJson() => {
        DbBookFields.status: status,
        DbBookFields.title: title,
        DbBookFields.author: author,
        DbBookFields.readPagesAmount: readPagesAmount,
        DbBookFields.allPagesAmount: allPagesAmount,
      };

  DbBook copyWith({
    String? id,
    Uint8List? imageData,
    String? userId,
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) {
    return DbBook(
      id: id ?? this.id,
      imageData: imageData ?? this.imageData,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }
}

class DbBookFields {
  static const String id = '_id';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
}

DbBook createDbBook({
  String? id,
  Uint8List? imageData,
  String userId = '',
  String status = 'unread',
  String title = '',
  String author = '',
  int readPagesAmount = 0,
  int allPagesAmount = 0,
}) {
  return DbBook(
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
