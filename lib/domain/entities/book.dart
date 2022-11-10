import 'package:app/models/entity.dart';
import 'package:app/models/image.dart';

class Book extends Entity {
  final String userId;
  final BookStatus status;
  final Image? image;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const Book({
    required super.id,
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
        id,
        userId,
        status,
        image ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  Book copyWith({
    String? id,
    String? userId,
    BookStatus? status,
    Image? image,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) {
    return Book(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      image: image ?? this.image,
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
  Image? image,
  String title = '',
  String author = '',
  int readPagesAmount = 0,
  int allPagesAmount = 0,
}) {
  return Book(
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
