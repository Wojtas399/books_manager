part of 'home_bloc.dart';

class HomeState extends BlocState {
  final int currentPageIndex;

  const HomeState({
    required super.status,
    required this.currentPageIndex,
  });

  @override
  List<Object> get props => [
        status,
        currentPageIndex,
      ];

  HomeState copyWith({
    BlocStatus? status,
    int? currentPageIndex,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}
