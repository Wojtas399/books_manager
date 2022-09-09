import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';

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
    required Uint8List? imageData,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    await _bookInterface.addNewBook(
      userId: userId,
      status: status,
      imageData: imageData,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }
}
