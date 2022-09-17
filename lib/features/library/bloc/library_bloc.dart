import 'dart:async';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_all_user_books_use_case.dart';
import 'package:app/domain/use_cases/book/load_all_user_books_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  late final LoadAllUserBooksUseCase _loadAllUserBooksUseCase;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetAllUserBooksUseCase _getAllUserBooksUseCase;
  StreamSubscription<List<Book>>? _booksListener;

  LibraryBloc({
    required LoadAllUserBooksUseCase loadAllUserBooksUseCase,
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetAllUserBooksUseCase getAllUserBooksUseCase,
    BlocStatus status = const BlocStatusInitial(),
    List<Book> books = const [],
  }) : super(
          LibraryState(
            status: status,
            books: books,
          ),
        ) {
    _loadAllUserBooksUseCase = loadAllUserBooksUseCase;
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getAllUserBooksUseCase = getAllUserBooksUseCase;
    on<LibraryEventInitialize>(_initialize);
    on<LibraryEventBooksUpdated>(_booksUpdated);
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
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emit(state.copyWith(
        status: const BlocStatusLoggedUserNotFound(),
      ));
    } else {
      await _loadAllUserBooksUseCase.execute(userId: loggedUserId);
      _setBooksListener(loggedUserId);
    }
  }

  void _booksUpdated(
    LibraryEventBooksUpdated event,
    Emitter<LibraryState> emit,
  ) {
    emit(state.copyWith(
      books: event.books,
    ));
  }

  void _setBooksListener(String loggedUserId) {
    _booksListener ??=
        _getAllUserBooksUseCase.execute(userId: loggedUserId).listen(
              (List<Book> books) => add(
                LibraryEventBooksUpdated(books: books),
              ),
            );
  }
}
