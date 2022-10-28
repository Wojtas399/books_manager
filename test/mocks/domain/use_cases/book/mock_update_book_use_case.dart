import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:app/models/image_file.dart';
import 'package:mocktail/mocktail.dart';

class FakeImageFile extends Fake implements ImageFile {}

class MockUpdateBookUseCase extends Mock implements UpdateBookUseCase {
  void mock() {
    _mockImageFile();
    when(
      () => execute(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
        imageFile: any(named: 'imageFile'),
        deleteImage: any(named: 'deleteImage'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockImageFile() {
    registerFallbackValue(FakeImageFile());
  }
}
