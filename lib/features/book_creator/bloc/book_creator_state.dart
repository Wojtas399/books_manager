part of 'book_creator_bloc.dart';

class BookCreatorState extends BlocState {
  final Image? image;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const BookCreatorState({
    required super.status,
    required this.image,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        status,
        image ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  @override
  BookCreatorState copyWith({
    BlocStatus? status,
    Image? image,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool deletedImage = false,
  }) {
    return BookCreatorState(
      status: status ?? const BlocStatusInProgress(),
      image: deletedImage ? null : image ?? this.image,
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
