abstract class BookInterface {
  Future<void> addNewBook({
    required String title,
    required String author,
    required int allPagesAmount,
    required int readPagesAmount,
  });
}
