part of 'book_preview_bloc.dart';

class BookPreviewState extends BlocState {
  late final Book? _book;

  BookPreviewState({
    required super.status,
    required Book? book,
  }) {
    _book = book;
  }

  @override
  List<Object> get props => [
        status,
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
      status: status ?? const BlocStatusInProgress(),
      book: book ?? _book,
    );
  }
}