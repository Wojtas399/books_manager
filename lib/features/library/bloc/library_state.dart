part of 'library_bloc.dart';

class LibraryState extends BlocState {
  final List<Book> books;

  const LibraryState({
    required super.status,
    required this.books,
  });

  @override
  List<Object> get props => [
        status,
        books,
      ];

  LibraryState copyWith({
    BlocStatus? status,
    List<Book>? books,
  }) {
    return LibraryState(
      status: status ?? const BlocStatusComplete(),
      books: books ?? this.books,
    );
  }
}
