import 'dart:async';

import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final InitializeUserDataUseCase _initializeUserDataUseCase;

  HomeBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required InitializeUserDataUseCase initializeUserDataUseCase,
    BlocStatus status = const BlocStatusInitial(),
    int currentPageIndex = 0,
  }) : super(
          HomeState(
            status: status,
            currentPageIndex: currentPageIndex,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _initializeUserDataUseCase = initializeUserDataUseCase;
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
      await _initializeUserDataUseCase.execute(userId: loggedUserId);
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
