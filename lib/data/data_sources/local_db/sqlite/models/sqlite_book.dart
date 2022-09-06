import 'dart:typed_data';

import 'package:app/data/models/db_book.dart';

class SqliteBook extends DbBook {
  final bool isDeleted;

  const SqliteBook({
    super.id,
    super.imageData,
    required super.userId,
    required super.status,
    required super.title,
    required super.author,
    required super.readPagesAmount,
    required super.allPagesAmount,
    required this.isDeleted,
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
        isDeleted,
      ];

  @override
  SqliteBook copyWith({
    String? id,
    Uint8List? imageData,
    String? userId,
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool? isDeleted,
  }) {
    return SqliteBook(
      id: id ?? this.id,
      imageData: imageData ?? this.imageData,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  SqliteBook.fromJson(Map<String, Object?> json)
      : this(
          id: json[SqliteBookFields.id] as String?,
          imageData: null,
          userId: json[SqliteBookFields.userId] as String,
          status: json[SqliteBookFields.status] as String,
          title: json[SqliteBookFields.title] as String,
          author: json[SqliteBookFields.author] as String,
          readPagesAmount: json[SqliteBookFields.readPagesAmount] as int,
          allPagesAmount: json[SqliteBookFields.allPagesAmount] as int,
          isDeleted: (json[SqliteBookFields.isDeleted] as int) == 1,
        );

  static String fromJsonToId(Map<String, Object?> json) {
    return json[SqliteBookFields.id] as String;
  }

  Map<String, Object?> toJson() => {
        SqliteBookFields.id: id,
        SqliteBookFields.userId: userId,
        SqliteBookFields.status: status,
        SqliteBookFields.title: title,
        SqliteBookFields.author: author,
        SqliteBookFields.readPagesAmount: readPagesAmount,
        SqliteBookFields.allPagesAmount: allPagesAmount,
        SqliteBookFields.isDeleted: isDeleted ? 1 : 0,
      };

  DbBook toDbBook() => DbBook(
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

class SqliteBookFields {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
  static const String isDeleted = 'isDeleted';
}

extension SqliteDbBookExtensions on DbBook {
  SqliteBook toSqliteBook({required bool isDeleted}) {
    return SqliteBook(
      id: id,
      imageData: imageData,
      userId: userId,
      status: status,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
      isDeleted: isDeleted,
    );
  }
}
