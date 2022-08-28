import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String userId;
  final BookStatus status;
  final Uint8List? imageData;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const Book({
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
        userId,
        status,
        imageData ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];
}

enum BookStatus {
  unread,
  inProgress,
  finished,
}

Book createBook({
  String userId = '',
  BookStatus status = BookStatus.unread,
  Uint8List? imageData,
  String title = '',
  String author = '',
  int readPagesAmount = 0,
  int allPagesAmount = 0,
}) {
  return Book(
    userId: userId,
    status: status,
    imageData: imageData,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
  );
}
