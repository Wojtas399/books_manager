import 'package:equatable/equatable.dart';

abstract class HomeActions extends Equatable {}

class HomeActionsUpdatePage extends HomeActions {
  final String bookId;
  final int newPage;

  HomeActionsUpdatePage({required this.bookId, required this.newPage});

  @override
  List<Object> get props => [bookId, newPage];
}

class HomeActionsNavigateToBookDetails extends HomeActions {
  final String bookId;

  HomeActionsNavigateToBookDetails({required this.bookId});

  @override
  List<Object> get props => [bookId];
}
