import 'dart:async';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_books_in_progress_of_user_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'reading_event.dart';
part 'reading_state.dart';

class ReadingBloc extends CustomBloc<ReadingEvent, ReadingState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetBooksInProgressOfUserUseCase _getBooksInProgressOfUserUseCase;
  StreamSubscription<List<Book>?>? _booksInProgressListener;

  ReadingBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetBooksInProgressOfUserUseCase getBooksInProgressOfUserUseCase,
    BlocStatus status = const BlocStatusInitial(),
    List<Book>? booksInProgress,
  }) : super(
          ReadingState(
            status: status,
            booksInProgress: booksInProgress,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getBooksInProgressOfUserUseCase = getBooksInProgressOfUserUseCase;
    on<ReadingEventInitialize>(_initialize);
    on<ReadingEventBooksInProgressUpdated>(_booksInProgressUpdated);
  }

  @override
  Future<void> close() {
    _booksInProgressListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    ReadingEventInitialize event,
    Emitter<ReadingState> emit,
  ) async {
    emitLoadingStatus(emit);
    _booksInProgressListener = _getLoggedUserIdUseCase
        .execute()
        .switchMap(_getUserBooksInProgress)
        .listen(
          (List<Book>? books) => add(
            ReadingEventBooksInProgressUpdated(booksInProgress: books),
          ),
        );
  }

  void _booksInProgressUpdated(
    ReadingEventBooksInProgressUpdated event,
    Emitter<ReadingState> emit,
  ) {
    emit(state.copyWith(
      booksInProgress: event.booksInProgress,
    ));
  }

  Stream<List<Book>?> _getUserBooksInProgress(String? loggedUserId) {
    if (loggedUserId == null) {
      return Stream.value(null);
    }
    return _getBooksInProgressOfUserUseCase.execute(userId: loggedUserId);
  }
}
