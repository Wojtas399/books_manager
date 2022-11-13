import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/image.dart';

class UpdateBookUseCase {
  late final BookInterface _bookInterface;

  UpdateBookUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String bookId,
    required String userId,
    Image? image,
    bool deleteImage = false,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) async {
    if (deleteImage) {
      await _bookInterface.deleteBookImage(
        bookId: bookId,
        userId: userId,
      );
    }
    await _bookInterface.updateBook(
      bookId: bookId,
      userId: userId,
      image: deleteImage ? null : image,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }
}
