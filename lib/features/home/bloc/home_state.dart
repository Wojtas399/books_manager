part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int currentPageIndex;

  const HomeState({
    required this.currentPageIndex,
  });

  @override
  List<Object> get props => [
        currentPageIndex,
      ];

  HomeState copyWith({
    int? currentPageIndex,
  }) {
    return HomeState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}
