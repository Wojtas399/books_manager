import 'dart:async';

import 'package:app/domain/entities/user.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:app/domain/use_cases/user/load_user_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final InitializeUserDataUseCase _initializeUserDataUseCase;
  late final LoadUserUseCase _loadUserUseCase;
  late final GetUserUseCase _getUserUseCase;

  HomeBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required InitializeUserDataUseCase initializeUserDataUseCase,
    required LoadUserUseCase loadUserUseCase,
    required GetUserUseCase getUserUseCase,
    BlocStatus status = const BlocStatusInitial(),
    int currentPageIndex = 0,
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
  }) : super(
          HomeState(
            status: status,
            currentPageIndex: currentPageIndex,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _initializeUserDataUseCase = initializeUserDataUseCase;
    _loadUserUseCase = loadUserUseCase;
    _getUserUseCase = getUserUseCase;
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
      await _loadUserUseCase.execute(userId: loggedUserId);
      await _setInitialThemeSettings(loggedUserId, emit);
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

  Future<void> _setInitialThemeSettings(
    String userId,
    Emitter<HomeState> emit,
  ) async {
    final User user = await _getUserUseCase.execute(userId: userId).first;
    emit(state.copyWith(
      isDarkModeOn: user.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          user.isDarkModeCompatibilityWithSystemOn,
    ));
  }
}
