import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/image.dart';
import 'package:mocktail/mocktail.dart';

class FakeImage extends Fake implements Image {}

class MockBookInterface extends Mock implements BookInterface {
  void mockGetBook({required Book book}) {
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

  void mockAddNewBook() {
    _mockBookStatus();
    _mockImage();
    when(
      () => addNewBook(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        image: any(named: 'image'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBook() {
    _mockBookStatus();
    _mockImage();
    when(
      () => updateBook(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        image: any(named: 'image'),
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

  void mockDeleteAllUserBooks() {
    when(
      () => deleteAllUserBooks(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockBookStatus() {
    registerFallbackValue(BookStatus.unread);
  }

  void _mockImage() {
    registerFallbackValue(FakeImage());
  }
}
