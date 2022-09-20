import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/models/db_book.dart';
import 'package:mocktail/mocktail.dart';

class FakeDbBook extends Fake implements DbBook {}

class MockBookRemoteDbService extends Mock implements BookRemoteDbService {
  void mockLoadUserBooks({required List<DbBook> dbBooks}) {
    when(
      () => loadUserBooks(userId: any(named: 'userId')),
    ).thenAnswer((_) async => dbBooks);
  }

  void mockAddBook() {
    registerFallbackValue(FakeDbBook());
    when(
      () => addBook(dbBook: any(named: 'dbBook')),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBookData() {
    when(
      () => updateBookData(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
        status: any(named: 'status'),
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
        userId: any(named: 'userId'),
        imageData: any(named: 'imageData'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockDeleteBook() {
    when(
      () => deleteBook(
        userId: any(named: 'userId'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
