part of 'library_bloc.dart';

class LibraryState extends BlocState {
  late final String searchValue;
  late final List<Book>? _books;

  LibraryState({
    required super.status,
    required this.searchValue,
    required List<Book>? books,
  }) {
    _books = books;
  }

  @override
  List<Object> get props => [
        status,
        searchValue,
        _books ?? '',
      ];

  @override
  LibraryState copyWith({
    BlocStatus? status,
    String? searchValue,
    List<Book>? books,
  }) {
    return LibraryState(
      status: status ?? const BlocStatusComplete(),
      searchValue: searchValue ?? this.searchValue,
      books: books ?? _books,
    );
  }

  List<Book>? get books {
    if (searchValue.isEmpty) {
      return _books;
    }
    return _books?.where(_doesBookMatchToSearchValue).toList();
  }

  bool _doesBookMatchToSearchValue(Book book) {
    final bool doesTitleMatchToSearchValue = book.title.contains(searchValue);
    final bool doesAuthorMatchToSearchValue = book.author.contains(searchValue);
    return doesTitleMatchToSearchValue || doesAuthorMatchToSearchValue;
  }
}
