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

  List<Book> get sortedBooks {
    final List<Book> sortedBooks = [...books];
    sortedBooks.sort(
      (Book book1, Book book2) => book1.title.compareTo(book2.title),
    );
    return sortedBooks;
  }

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
