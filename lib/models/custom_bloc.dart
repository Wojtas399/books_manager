import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBloc<Event, State extends BlocState> extends Bloc<Event, State> {
  CustomBloc(super.initialState);

  void emitLoadingStatus(Emitter<State> emit) {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
  }

  void emitInfo<T>(Emitter<State> emit, T info) {
    emit(state.copyWith(
      status: BlocStatusComplete<T>(info: info),
    ));
  }

  void emitError<T>(Emitter<State> emit, T error) {
    emit(state.copyWith(
      status: BlocStatusError<T>(error: error),
    ));
  }

  void emitLossOfInternetConnectionStatus(Emitter<State> emit) {
    emit(state.copyWith(
      status: const BlocStatusLossOfInternetConnection(),
    ));
  }

  void emitTimeoutExceptionStatus(Emitter<State> emit) {
    emit(state.copyWith(
      status: const BlocStatusTimeoutException(),
    ));
  }
}
