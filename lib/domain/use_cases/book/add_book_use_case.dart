import '../../../interfaces/book_interface.dart';

class AddBookUseCase {
  late final BookInterface _bookInterface;

  AddBookUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    await _bookInterface.addNewBook(
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }
}
