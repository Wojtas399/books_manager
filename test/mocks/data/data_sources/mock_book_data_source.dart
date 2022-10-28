import 'package:app/data/data_sources/book_data_source.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/image_file.dart';
import 'package:mocktail/mocktail.dart';

class FakeImageFile extends Fake implements ImageFile {}

class MockBookDataSource extends Mock implements BookDataSource {
  void mockGetBook({required Book? book}) {
    when(
      () => getBook(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(book));
  }

  void mockGetUserBooks({required List<Book> userBooks}) {
    _mockBookStatus();
    when(
      () => getUserBooks(
        userId: any(named: 'userId'),
        bookStatus: any(named: 'bookStatus'),
      ),
    ).thenAnswer((_) => Stream.value(userBooks));
  }

  void mockAddBook() {
    _mockBookStatus();
    _mockImageFile();
    when(
      () => addBook(
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

  void mockUpdateBook() {
    _mockBookStatus();
    _mockImageFile();
    when(
      () => updateBook(
        bookId: any(named: 'bookId'),
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

  void mockDeleteBookImage() {
    when(
      () => deleteBookImage(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockDeleteBook() {
    when(
      () => deleteBook(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
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
