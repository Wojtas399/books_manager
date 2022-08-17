import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'initial_home_event.dart';

part 'initial_home_state.dart';

class InitialHomeBloc extends Bloc<InitialHomeEvent, InitialHomeState> {
  InitialHomeBloc({
    InitialHomeMode mode = InitialHomeMode.signIn,
  }) : super(
          InitialHomeState(mode: mode),
        ) {
    on<InitialHomeEventChangeMode>(_changeMode);
  }

  void _changeMode(
    InitialHomeEventChangeMode event,
    Emitter<InitialHomeState> emit,
  ) {
    emit(state.copyWith(
      mode: event.mode,
    ));
  }
}
