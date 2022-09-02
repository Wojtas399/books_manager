import '../../../interfaces/book_interface.dart';
import '../../entities/book.dart';

class AddBookUseCase {
  late final BookInterface _bookInterface;

  AddBookUseCase({
    required BookInterface bookInterface,
  }) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required Book book}) async {
    await _bookInterface.addNewBook(book: book);
  }
}
