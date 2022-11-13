part of 'internet_connection_checker_bloc.dart';

class InternetConnectionCheckerState extends BlocState {
  final bool hasInternetConnection;

  const InternetConnectionCheckerState({
    required super.status,
    required this.hasInternetConnection,
  });

  @override
  List<Object> get props => [
        status,
        hasInternetConnection,
      ];

  @override
  InternetConnectionCheckerState copyWith({
    BlocStatus? status,
    bool? hasInternetConnection,
  }) {
    return InternetConnectionCheckerState(
      status:
          status ?? const BlocStatusComplete<InternetConnectionCheckerInfo>(),
      hasInternetConnection:
          hasInternetConnection ?? this.hasInternetConnection,
    );
  }
}

enum InternetConnectionCheckerInfo {
  stillHasNotInternetConnection,
}
