import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/image_file.dart';
import 'package:mocktail/mocktail.dart';

class FakeImageFile extends Fake implements ImageFile {}

class MockBookInterface extends Mock implements BookInterface {
  void mockGetBook({required Book book}) {
    when(
      () => getBook(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(book));
  }

  void mockGetUserBooks({List<Book>? books}) {
    _mockBookStatus();
    when(
      () => getUserBooks(
        userId: any(named: 'userId'),
        bookStatus: any(named: 'bookStatus'),
      ),
    ).thenAnswer((_) => Stream.value(books));
  }

  void mockAddNewBook() {
    _mockBookStatus();
    _mockImageFile();
    when(
      () => addNewBook(
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

  void _mockImageFile() {
    registerFallbackValue(FakeImageFile());
  }
}
