part of 'book_creator_bloc.dart';

class BookCreatorState extends BlocState {
  final Uint8List? imageData;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const BookCreatorState({
    required super.status,
    required this.imageData,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        status,
        imageData ?? '',
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
    Uint8List? imageData,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool deletedImage = false,
  }) {
    return BookCreatorState(
      status: status ?? const BlocStatusInProgress(),
      imageData: deletedImage ? null : imageData ?? this.imageData,
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
