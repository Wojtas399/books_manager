import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/book.dart';
import '../../../domain/use_cases/auth/get_logged_user_id_use_case.dart';
import '../../../domain/use_cases/book/get_books_by_user_id_use_case.dart';
import '../../../domain/use_cases/book/load_all_books_by_user_id_use_case.dart';
import '../../../models/bloc_state.dart';
import '../../../models/bloc_status.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  late final LoadAllBooksByUserIdUseCase _loadAllBooksByUserIdUseCase;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetBooksByUserIdUseCase _getBooksByUserIdUseCase;
  StreamSubscription<List<Book>>? _booksListener;

  LibraryBloc({
    required LoadAllBooksByUserIdUseCase loadAllBooksByUserIdUseCase,
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetBooksByUserIdUseCase getBooksByUserIdUseCase,
    BlocStatus status = const BlocStatusInitial(),
    List<Book> books = const [],
  }) : super(
          LibraryState(
            status: status,
            books: books,
          ),
        ) {
    _loadAllBooksByUserIdUseCase = loadAllBooksByUserIdUseCase;
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getBooksByUserIdUseCase = getBooksByUserIdUseCase;
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
      await _loadAllBooksByUserIdUseCase.execute(userId: loggedUserId);
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
        _getBooksByUserIdUseCase.execute(userId: loggedUserId).listen(
              (List<Book> books) => add(
                LibraryEventBooksUpdated(books: books),
              ),
            );
  }
}
