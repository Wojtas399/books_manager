part of 'book_editor_bloc.dart';

class BookEditorState extends BlocState {
  final Book? originalBook;
  final Uint8List? imageData;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const BookEditorState({
    required super.status,
    required this.originalBook,
    required this.imageData,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  List<Object> get props => [
        status,
        originalBook ?? '',
        imageData ?? '',
        title,
        author,
        readPagesAmount,
        allPagesAmount,
      ];

  bool get isButtonDisabled =>
      imageData == originalBook?.imageData &&
      title == originalBook?.title &&
      author == originalBook?.author &&
      readPagesAmount == originalBook?.readPagesAmount &&
      allPagesAmount == originalBook?.allPagesAmount;

  BookEditorState copyWith({
    BlocStatus? status,
    Book? originalBook,
    Uint8List? imageData,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    bool deleteImage = false,
  }) {
    return BookEditorState(
      status: status ?? const BlocStatusInProgress(),
      originalBook: originalBook ?? this.originalBook,
      imageData: deleteImage ? null : imageData ?? this.imageData,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }

  BookEditorState copyWithInfo(BookEditorBlocInfo info) {
    return copyWith(
      status: BlocStatusComplete<BookEditorBlocInfo>(info: info),
    );
  }
}

enum BookEditorBlocInfo {
  bookHasBeenUpdated,
}
