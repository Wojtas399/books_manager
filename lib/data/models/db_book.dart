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
