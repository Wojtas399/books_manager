import 'dart:async';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_all_user_books_use_case.dart';
import 'package:app/domain/use_cases/book/load_all_user_books_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends CustomBloc<LibraryEvent, LibraryState> {
  late final LoadAllUserBooksUseCase _loadAllUserBooksUseCase;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetAllUserBooksUseCase _getAllUserBooksUseCase;
  StreamSubscription<List<Book>?>? _booksListener;

  LibraryBloc({
    required LoadAllUserBooksUseCase loadAllUserBooksUseCase,
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
    _loadAllUserBooksUseCase = loadAllUserBooksUseCase;
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getAllUserBooksUseCase = getAllUserBooksUseCase;
    on<LibraryEventInitialize>(_initialize);
    on<LibraryEventBooksUpdated>(_booksUpdated);
    on<LibraryEventSearchValueChanged>(_searchValueChanged);
  }

  @override
  Future<void> close() async {
    _booksListener?.cancel();
    super.close();
  }

  Future<void> _initialize(
    LibraryEventInitialize event,
    Emitter<LibraryState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    if (await _areLoggedUserBooksNotLoaded(loggedUserId)) {
      emitLoadingStatus(emit);
    }
    _setBooksListener(loggedUserId);
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    await _loadAllUserBooksUseCase.execute(userId: loggedUserId);
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

  Future<bool> _areLoggedUserBooksNotLoaded(String loggedUserId) async {
    return await _getAllLoggedUserBooks(loggedUserId).first == null;
  }

  void _setBooksListener(String loggedUserId) {
    _booksListener ??= _getAllLoggedUserBooks(loggedUserId).listen(
      (List<Book>? books) {
        if (books != null) {
          add(LibraryEventBooksUpdated(books: books));
        }
      },
    );
  }

  Stream<List<Book>?> _getAllLoggedUserBooks(String loggedUserId) {
    return _getAllUserBooksUseCase.execute(userId: loggedUserId);
  }
}
