part of 'book_creator_bloc.dart';

class BookCreatorState extends BlocState {
  final ImageFile? imageFile;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const BookCreatorState({
    required super.status,
    required this.imageFile,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        status,
        imageFile ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  @override
  BookCreatorState copyWith({
    BlocStatus? status,
    ImageFile? imageFile,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool deletedImage = false,
  }) {
    return BookCreatorState(
      status: status ?? const BlocStatusInProgress(),
      imageFile: deletedImage ? null : imageFile ?? this.imageFile,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }

  bool get isButtonDisabled =>
      title.isEmpty ||
      author.isEmpty ||
      allPagesAmount == 0 ||
      allPagesAmount < readPagesAmount;
}

enum BookCreatorBlocInfo {
  bookHasBeenAdded,
}
