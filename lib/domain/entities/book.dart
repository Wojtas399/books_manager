import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String userId;
  final BookStatus status;
  final Uint8List? imageData;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const Book({
    required this.id,
    required this.userId,
    required this.status,
    required this.imageData,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        status,
        imageData ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  Book copyWith({
    String? id,
    String? userId,
    BookStatus? status,
    Uint8List? imageData,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) {
    return Book(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      imageData: imageData ?? this.imageData,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }
}

enum BookStatus {
  unread,
  inProgress,
  finished,
}

Book createBook({
  String id = 'b1',
  String userId = '',
  BookStatus status = BookStatus.unread,
  Uint8List? imageData,
  String title = '',
  String author = '',
  int readPagesAmount = 0,
  int allPagesAmount = 0,
}) {
  return Book(
    id: id,
    userId: userId,
    status: status,
    imageData: imageData,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
  );
}
