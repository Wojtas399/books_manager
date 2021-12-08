abstract class HomeActions {}

class UpdatePages extends HomeActions {
  final String bookId;
  final int newPage;

  UpdatePages({required this.bookId, required this.newPage});
}
