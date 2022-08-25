import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    int currentPageIndex = 0,
  }) : super(
          HomeState(
            currentPageIndex: currentPageIndex,
          ),
        ) {
    on<HomeEventChangePage>(_changePage);
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
