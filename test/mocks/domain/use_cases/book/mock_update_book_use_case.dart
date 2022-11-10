import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:app/models/image.dart';
import 'package:mocktail/mocktail.dart';

class FakeImage extends Fake implements Image {}

class MockUpdateBookUseCase extends Mock implements UpdateBookUseCase {
  void mock() {
    _mockImage();
    when(
      () => execute(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
        image: any(named: 'image'),
        deleteImage: any(named: 'deleteImage'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockImage() {
    registerFallbackValue(FakeImage());
  }
}
