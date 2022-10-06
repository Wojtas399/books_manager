import 'dart:async';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_user_books_in_progress_use_case.dart';
import 'package:app/domain/use_cases/book/load_user_books_in_progress_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reading_event.dart';
part 'reading_state.dart';

class ReadingBloc extends CustomBloc<ReadingEvent, ReadingState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final LoadUserBooksInProgressUseCase _loadUserBooksInProgressUseCase;
  late final GetUserBooksInProgressUseCase _getUserBooksInProgressUseCase;
  StreamSubscription<List<Book>>? _booksInProgressListener;

  ReadingBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required LoadUserBooksInProgressUseCase loadUserBooksInProgressUseCase,
    required GetUserBooksInProgressUseCase getUserBooksInProgressUseCase,
    BlocStatus status = const BlocStatusInitial(),
    List<Book> booksInProgress = const [],
  }) : super(
          ReadingState(
            status: status,
            booksInProgress: booksInProgress,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _loadUserBooksInProgressUseCase = loadUserBooksInProgressUseCase;
    _getUserBooksInProgressUseCase = getUserBooksInProgressUseCase;
    on<ReadingEventInitialize>(_initialize);
    on<ReadingEventBooksInProgressUpdated>(_booksInProgressUpdated);
  }

  @override
  Future<void> close() async {
    super.close();
    _booksInProgressListener?.cancel();
  }

  Future<void> _initialize(
    ReadingEventInitialize event,
    Emitter<ReadingState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId != null) {
      emitLoadingStatus(emit);
      await _loadUserBooksInProgressUseCase.execute(userId: loggedUserId);
      _setBooksInProgressListener(loggedUserId);
    }
  }

  void _booksInProgressUpdated(
    ReadingEventBooksInProgressUpdated event,
    Emitter<ReadingState> emit,
  ) {
    emit(state.copyWith(
      booksInProgress: event.booksInProgress,
    ));
  }

  void _setBooksInProgressListener(String userId) {
    _booksInProgressListener ??=
        _getUserBooksInProgressUseCase.execute(userId: userId).listen(
      (List<Book> booksInProgress) {
        add(
          ReadingEventBooksInProgressUpdated(booksInProgress: booksInProgress),
        );
      },
    );
  }
}
