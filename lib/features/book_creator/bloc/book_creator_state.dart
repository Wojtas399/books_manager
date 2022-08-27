part of 'book_creator_bloc.dart';

class BookCreatorState extends Equatable {
  final BlocStatus status;
  final String? imagePath;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const BookCreatorState({
    required this.status,
    required this.imagePath,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        status,
        imagePath ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  bool get isButtonDisabled =>
      title.isEmpty ||
      author.isEmpty ||
      allPagesAmount == 0 ||
      allPagesAmount < readPagesAmount;

  BookCreatorState copyWith({
    BlocStatus? status,
    String? imagePath,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool removedImagePath = false,
  }) {
    return BookCreatorState(
      status: status ?? const BlocStatusInProgress(),
      imagePath: removedImagePath ? null : imagePath ?? this.imagePath,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }

  BookCreatorState copyWithInfo(BookCreatorBlocInfo info) {
    return copyWith(
      status: BlocStatusComplete<BookCreatorBlocInfo>(info: info),
    );
  }
}

enum BookCreatorBlocInfo {
  bookHasBeenAdded,
}
