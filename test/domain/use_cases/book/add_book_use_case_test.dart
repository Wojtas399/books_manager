import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = AddBookUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for adding new book',
    () async {
      const String userId = 'u1';
      const BookStatus status = BookStatus.unread;
      final Uint8List imageData = Uint8List(1);
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 0;
      const int allPagesAmount = 200;
      bookInterface.mockAddNewBook();

      await useCase.execute(
        userId: userId,
        status: status,
        imageData: imageData,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );

      verify(
        () => bookInterface.addNewBook(
          userId: userId,
          status: status,
          imageData: imageData,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        ),
      ).called(1);
    },
  );
}
