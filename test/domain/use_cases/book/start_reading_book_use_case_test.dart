import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  late StartReadingBookUseCase useCase;
  const String bookId = 'b1';

  setUp(() {
    useCase = StartReadingBookUseCase(bookInterface: bookInterface);
    bookInterface.mockUpdateBookData();
  });

  tearDown(() {
    reset(bookInterface);
  });

  test(
    'should call method responsible for updating book with book status set as in progress',
    () async {
      await useCase.execute(bookId: bookId);

      verify(
        () => bookInterface.updateBookData(
          bookId: bookId,
          bookStatus: BookStatus.inProgress,
        ),
      ).called(1);
    },
  );

  test(
    'from beginning, should call method responsible for updating book with book status set as in progress and read pages amount set as 0',
    () async {
      await useCase.execute(bookId: bookId, fromBeginning: true);

      verify(
        () => bookInterface.updateBookData(
          bookId: bookId,
          bookStatus: BookStatus.inProgress,
          readPagesAmount: 0,
        ),
      ).called(1);
    },
  );
}
