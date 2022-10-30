part of 'book_editor_bloc.dart';

class BookEditorState extends BlocState {
  final Book? originalBook;
  final ImageFile? imageFile;
  final String? title;
  final String? author;
  final int? readPagesAmount;
  final int? allPagesAmount;

  const BookEditorState({
    required super.status,
    required this.originalBook,
    required this.imageFile,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        status,
        originalBook ?? '',
        imageFile ?? '',
        title ?? '',
        author ?? '',
        readPagesAmount ?? 0,
        allPagesAmount ?? 0,
      ];

  @override
  BookEditorState copyWith({
    BlocStatus? status,
    Book? originalBook,
    ImageFile? imageFile,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool deletedImage = false,
  }) {
    return BookEditorState(
      status: status ?? const BlocStatusInProgress(),
      originalBook: originalBook ?? this.originalBook,
      imageFile: deletedImage ? null : imageFile ?? this.imageFile,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }

  bool get isButtonDisabled =>
      imageFile == originalBook?.imageFile &&
      title == originalBook?.title &&
      author == originalBook?.author &&
      readPagesAmount == originalBook?.readPagesAmount &&
      allPagesAmount == originalBook?.allPagesAmount;
}

enum BookEditorBlocInfo {
  bookHasBeenUpdated,
}
