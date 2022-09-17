part of 'book_preview_bloc.dart';

class BookPreviewState extends BlocState {
  late final String bookId;
  late final Uint8List? initialBookImageData;
  late final Book? _book;

  BookPreviewState({
    required super.status,
    required this.bookId,
    required this.initialBookImageData,
    required Book? book,
  }) {
    _book = book;
  }

  @override
  List<Object> get props => [
        status,
        bookId,
        initialBookImageData ?? '',
        _book ?? '',
      ];

  Uint8List? get bookImageData => _book?.imageData;

  BookStatus? get bookStatus => _book?.status;

  String? get title => _book?.title;

  String? get author => _book?.author;

  int? get readPagesAmount => _book?.readPagesAmount;

  int? get allPagesAmount => _book?.allPagesAmount;

  BookPreviewState copyWith({
    BlocStatus? status,
    Book? book,
  }) {
    return BookPreviewState(
      bookId: bookId,
      status: status ?? const BlocStatusInProgress(),
      book: book ?? _book,
      initialBookImageData: initialBookImageData,
    );
  }

  BookPreviewState copyWithInfo(BookPreviewBlocInfo info) {
    return copyWith(
      status: BlocStatusComplete<BookPreviewBlocInfo>(info: info),
    );
  }

  BookPreviewState copyWithError(BookPreviewBlocError error) {
    return copyWith(
      status: BlocStatusError<BookPreviewBlocError>(error: error),
    );
  }
}

enum BookPreviewBlocInfo {
  currentPageNumberHasBeenUpdated,
  bookHasBeenDeleted,
}

enum BookPreviewBlocError {
  newCurrentPageNumberIsTooHigh,
}
