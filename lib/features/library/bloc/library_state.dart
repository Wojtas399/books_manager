part of 'library_bloc.dart';

class LibraryState extends BlocState {
  final List<Book>? books;

  const LibraryState({
    required super.status,
    this.books,
  });

  @override
  List<Object> get props => [
        status,
        books ?? '',
      ];

  @override
  LibraryState copyWith({
    BlocStatus? status,
    List<Book>? books,
  }) {
    return LibraryState(
      status: status ?? const BlocStatusComplete(),
      books: books ?? this.books,
    );
  }

  List<Book>? get sortedBooks {
    if (books == null) {
      return null;
    }
    final List<Book> sortedBooks = [...?books];
    sortedBooks.sort(
      (Book book1, Book book2) => book1.title.compareTo(book2.title),
    );
    return sortedBooks;
  }
}
