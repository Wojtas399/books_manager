part of 'home_bloc.dart';

class HomeState extends BlocState {
  final int currentPageIndex;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;

  const HomeState({
    required super.status,
    required this.currentPageIndex,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
  });

  @override
  List<Object> get props => [
        status,
        currentPageIndex,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
      ];

  HomeState copyWith({
    BlocStatus? status,
    int? currentPageIndex,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
    );
  }
}
