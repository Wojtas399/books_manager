import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class UpdateBookUseCase {
  late final BookInterface _bookInterface;

  UpdateBookUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({
    required String bookId,
    required String userId,
    Uint8List? imageData,
    bool deleteImage = false,
    BookStatus? bookStatus,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) async {
    if (imageData != null) {
      await _bookInterface.updateBookImage(
        bookId: bookId,
        userId: userId,
        imageData: imageData,
      );
    } else if (deleteImage) {
      await _bookInterface.updateBookImage(
        bookId: bookId,
        userId: userId,
        imageData: null,
      );
    }
    await _bookInterface.updateBookData(
      bookId: bookId,
      userId: userId,
      bookStatus: bookStatus,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }
}
