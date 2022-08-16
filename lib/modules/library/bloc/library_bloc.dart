import 'package:app/core/book/book_query.dart';
import 'package:app/modules/library/bloc/library_actions.dart';
import 'package:app/modules/library/bloc/library_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryBloc extends Bloc<LibraryActions, LibraryQuery> {
  BookQuery bookQuery;

  LibraryBloc({required this.bookQuery})
      : super(LibraryQuery(bookQuery: bookQuery));
}
