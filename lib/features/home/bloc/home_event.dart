part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeEventChangePage extends HomeEvent {
  final int pageIndex;

  HomeEventChangePage({required this.pageIndex});
}
