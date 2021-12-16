import 'package:equatable/equatable.dart';

abstract class HomeActions {}

class HomeBlocUpdatePage extends Equatable implements HomeActions {
  final String bookId;
  final int newPage;

  HomeBlocUpdatePage({required this.bookId, required this.newPage});

  @override
  List<Object> get props => [bookId, newPage];
}
