import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {
  void mockInitializeForUser() {
    when(
      () => initializeForUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockGetBookById({required Book book}) {
    when(
      () => getBookById(
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) => Stream.value(book));
  }

  void mockGetBooksByUserId({required List<Book> books}) {
    when(
      () => getBooksByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(books));
  }

  void mockLoadUserBooks() {
    _mockBookStatus();
    when(
      () => loadUserBooks(
        userId: any(named: 'userId'),
        bookStatus: any(named: 'bookStatus'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockAddNewBook() {
    _mockBookStatus();
    when(
      () => addNewBook(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        imageData: any(named: 'imageData'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBookData() {
    _mockBookStatus();
    when(
      () => updateBookData(
        bookId: any(named: 'bookId'),
        bookStatus: any(named: 'bookStatus'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBookImage() {
    when(
      () => updateBookImage(
        bookId: any(named: 'bookId'),
        imageData: any(named: 'imageData'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockDeleteBook() {
    when(
      () => deleteBook(
        bookId: any(named: 'bookId'),
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
}
