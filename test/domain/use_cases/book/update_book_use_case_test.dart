import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:app/models/image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  late UpdateBookUseCase useCase;
  const String bookId = 'b1';
  const String userId = 'u1';
  final Image newImage = createImage(fileName: 'i1');
  const String newTitle = 'title';
  const String newAuthor = 'author';
  const int newReadPagesAmount = 20;
  const int newAllPagesAmount = 200;

  setUp(() {
    useCase = UpdateBookUseCase(bookInterface: bookInterface);
    bookInterface.mockUpdateBook();
    bookInterface.mockDeleteBookImage();
  });

  tearDown(() {
    reset(bookInterface);
  });

  test(
    'should call method responsible for updating book',
    () async {
      await useCase.execute(
        bookId: bookId,
        userId: userId,
        image: newImage,
        title: newTitle,
        author: newAuthor,
        readPagesAmount: newReadPagesAmount,
        allPagesAmount: newAllPagesAmount,
      );

      verify(
        () => bookInterface.updateBook(
          bookId: bookId,
          userId: userId,
          image: newImage,
          title: newTitle,
          author: newAuthor,
          readPagesAmount: newReadPagesAmount,
          allPagesAmount: newAllPagesAmount,
        ),
      );
      verifyNever(
        () => bookInterface.deleteBookImage(
          bookId: bookId,
          userId: userId,
        ),
      );
    },
  );

  test(
    'delete image param is true, should call methods responsible for deleting book image and for updating book with image file set as null',
    () async {
      await useCase.execute(
        bookId: bookId,
        userId: userId,
        image: newImage,
        deleteImage: true,
        title: newTitle,
        author: newAuthor,
        readPagesAmount: newReadPagesAmount,
        allPagesAmount: newAllPagesAmount,
      );

      verify(
        () => bookInterface.updateBook(
          bookId: bookId,
          userId: userId,
          image: null,
          title: newTitle,
          author: newAuthor,
          readPagesAmount: newReadPagesAmount,
          allPagesAmount: newAllPagesAmount,
        ),
      );
      verify(
        () => bookInterface.deleteBookImage(
          bookId: bookId,
          userId: userId,
        ),
      ).called(1);
    },
  );
}
