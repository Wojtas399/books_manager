import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/auth/get_logged_user_id_use_case.dart';
import '../../../domain/use_cases/book/refresh_user_books_use_case.dart';
import '../../../models/bloc_state.dart';
import '../../../models/bloc_status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final RefreshUserBooksUseCase _refreshUserBooksUseCase;

  HomeBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required RefreshUserBooksUseCase refreshUserBooksUseCase,
    BlocStatus status = const BlocStatusInitial(),
    int currentPageIndex = 0,
  }) : super(
          HomeState(
            status: status,
            currentPageIndex: currentPageIndex,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _refreshUserBooksUseCase = refreshUserBooksUseCase;
    on<HomeEventInitialize>(_initialize);
    on<HomeEventChangePage>(_changePage);
  }

  Future<void> _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
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
      await _refreshUserBooksUseCase.execute(userId: loggedUserId);
      emit(state.copyWith(
        status: const BlocStatusComplete(),
      ));
    }
  }

  void _changePage(
    HomeEventChangePage event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      currentPageIndex: event.pageIndex,
    ));
  }
}
