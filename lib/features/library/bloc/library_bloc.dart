import 'dart:async';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_all_user_books_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends CustomBloc<LibraryEvent, LibraryState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetAllUserBooksUseCase _getAllUserBooksUseCase;
  StreamSubscription<List<Book>?>? _booksListener;

  LibraryBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetAllUserBooksUseCase getAllUserBooksUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String searchValue = '',
    List<Book>? books,
  }) : super(
          LibraryState(
            status: status,
            searchValue: searchValue,
            books: books,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getAllUserBooksUseCase = getAllUserBooksUseCase;
    on<LibraryEventInitialize>(_initialize);
    on<LibraryEventBooksUpdated>(_booksUpdated);
    on<LibraryEventSearchValueChanged>(_searchValueChanged);
  }

  @override
  Future<void> close() {
    _booksListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    LibraryEventInitialize event,
    Emitter<LibraryState> emit,
  ) async {
    emitLoadingStatus(emit);
    _booksListener =
        _getLoggedUserIdUseCase.execute().switchMap(_getAllUserBooks).listen(
              (List<Book>? books) => add(
                LibraryEventBooksUpdated(books: books),
              ),
            );
  }

  void _booksUpdated(
    LibraryEventBooksUpdated event,
    Emitter<LibraryState> emit,
  ) {
    emit(state.copyWith(
      books: event.books,
    ));
  }

  void _searchValueChanged(
    LibraryEventSearchValueChanged event,
    Emitter<LibraryState> emit,
  ) {
    emit(state.copyWith(
      searchValue: event.searchValue,
    ));
  }

  Stream<List<Book>?> _getAllUserBooks(String? loggedUserId) {
    if (loggedUserId == null) {
      return Stream.value(null);
    }
    return _getAllUserBooksUseCase.execute(userId: loggedUserId);
  }
}
