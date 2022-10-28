import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  late UpdateBookUseCase useCase;
  const String bookId = 'b1';

  setUp(() {
    useCase = UpdateBookUseCase(bookInterface: bookInterface);
    bookInterface.mockUpdateBook();
  });

  tearDown(() {
    reset(bookInterface);
  });

  // test(
  //   'should call method responsible for updating book data',
  //   () async {
  //     const String newTitle = 'title';
  //     const String newAuthor = 'author';
  //     const int newReadPagesAmount = 20;
  //     const int newAllPagesAmount = 200;
  //
  //     await useCase.execute(
  //       bookId: bookId,
  //       title: newTitle,
  //       author: newAuthor,
  //       readPagesAmount: newReadPagesAmount,
  //       allPagesAmount: newAllPagesAmount,
  //     );
  //
  //     verify(
  //       () => bookInterface.updateBookData(
  //         bookId: bookId,
  //         title: newTitle,
  //         author: newAuthor,
  //         readPagesAmount: newReadPagesAmount,
  //         allPagesAmount: newAllPagesAmount,
  //       ),
  //     );
  //     verifyNever(
  //       () => bookInterface.updateBookImage(
  //         bookId: bookId,
  //         imageData: null,
  //       ),
  //     );
  //   },
  // );
  //
  // test(
  //   'should call method responsible for updating book image if new image data is not null',
  //   () async {
  //     final Uint8List newImageData = Uint8List(10);
  //
  //     await useCase.execute(
  //       bookId: bookId,
  //       imageData: newImageData,
  //     );
  //
  //     verify(
  //       () => bookInterface.updateBookImage(
  //         bookId: bookId,
  //         imageData: newImageData,
  //       ),
  //     ).called(1);
  //   },
  // );
  //
  // test(
  //   'should call method responsible for updating book image with null if delete image param is true',
  //   () async {
  //     await useCase.execute(
  //       bookId: bookId,
  //       deleteImage: true,
  //     );
  //
  //     verify(
  //       () => bookInterface.updateBookImage(
  //         bookId: bookId,
  //         imageData: null,
  //       ),
  //     ).called(1);
  //   },
  // );
}
