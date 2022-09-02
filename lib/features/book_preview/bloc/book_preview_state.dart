part of 'book_preview_bloc.dart';

class BookPreviewState extends BlocState {
  final Book? book;

  const BookPreviewState({
    required super.status,
    required this.book,
  });

  @override
  List<Object> get props => [
        status,
        book ?? '',
      ];

  BookPreviewState copyWith({
    BlocStatus? status,
    Book? book,
  }) {
    return BookPreviewState(
      status: status ?? const BlocStatusInProgress(),
      book: book ?? this.book,
    );
  }
}
