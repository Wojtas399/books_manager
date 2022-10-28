import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/image_file.dart';

class AddBookUseCase {
  late final BookInterface _bookInterface;

  AddBookUseCase({
    required BookInterface bookInterface,
  }) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String userId,
    required BookStatus status,
    required ImageFile? imageFile,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    await _bookInterface.addNewBook(
      userId: userId,
      status: status,
      imageFile: imageFile,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }
}
