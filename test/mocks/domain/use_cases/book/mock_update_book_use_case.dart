import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateBookUseCase extends Mock implements UpdateBookUseCase {
  void mock() {
    when(
      () => execute(
        bookId: any(named: 'bookId'),
        imageData: any(named: 'imageData'),
        deleteImage: any(named: 'deleteImage'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }
}
