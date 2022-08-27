part of 'book_creator_bloc.dart';

class BookCreatorState extends Equatable {
  final String? imagePath;
  final String title;
  final String author;
  final int allPagesAmount;
  final int readPagesAmount;

  const BookCreatorState({
    this.imagePath,
    required this.title,
    required this.author,
    required this.allPagesAmount,
    required this.readPagesAmount,
  });

  @override
  List<Object> get props => [
        imagePath ?? '',
        title,
        author,
        allPagesAmount,
        readPagesAmount,
      ];

  bool get isButtonDisabled =>
      title.isEmpty ||
      author.isEmpty ||
      allPagesAmount == 0 ||
      allPagesAmount < readPagesAmount;

  BookCreatorState copyWith({
    String? imagePath,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool removedImagePath = false,
  }) {
    return BookCreatorState(
      imagePath: removedImagePath ? null : imagePath ?? this.imagePath,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }
}
