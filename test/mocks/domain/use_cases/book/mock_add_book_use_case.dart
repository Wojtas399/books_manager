import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:app/models/image_file.dart';
import 'package:mocktail/mocktail.dart';

class FakeImageFile extends Fake implements ImageFile {}

class MockAddBookUseCase extends Mock implements AddBookUseCase {
  void mock() {
    _mockBookStatus();
    _mockImageFile();
    when(
      () => execute(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        imageFile: any(named: 'imageFile'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockBookStatus() {
    registerFallbackValue(BookStatus.unread);
  }

  void _mockImageFile() {
    registerFallbackValue(FakeImageFile());
  }
}
