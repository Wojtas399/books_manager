part of 'initial_home_bloc.dart';

class InitialHomeState extends Equatable {
  final InitialHomeMode mode;

  const InitialHomeState({
    required this.mode,
  });

  @override
  List<Object> get props => [mode];

  InitialHomeState copyWith({
    InitialHomeMode? mode,
  }) {
    return InitialHomeState(mode: mode ?? this.mode);
  }
}

enum InitialHomeMode {
  signIn,
  signUp,
}
