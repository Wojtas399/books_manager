part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeEventInitialize extends HomeEvent {
  const HomeEventInitialize();
}

class HomeEventChangePage extends HomeEvent {
  final int pageIndex;

  const HomeEventChangePage({required this.pageIndex});
}
