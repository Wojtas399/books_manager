import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/domain/entities/book.dart';
import 'package:mocktail/mocktail.dart';

class FakeBook extends Fake implements Book {}

class MockBookLocalDbService extends Mock implements BookLocalDbService {
  void mockLoadUserBooks({required List<Book> books}) {
    _mockSyncState();
    when(
      () => loadUserBooks(
        userId: any(named: 'userId'),
        bookStatus: any(named: 'bookStatus'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => books);
  }

  void mockAddBook() {
    registerFallbackValue(FakeBook());
    _mockSyncState();
    when(
      () => addBook(
        book: any(named: 'book'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBookData({required Book updatedBook}) {
    _mockSyncState();
    when(
      () => updateBookData(
        bookId: any(named: 'bookId'),
        status: any(named: 'status'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => updatedBook);
  }

  void mockUpdateBookImage({required Book updatedBook}) {
    when(
      () => updateBookImage(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
        imageData: any(named: 'imageData'),
      ),
    ).thenAnswer((_) async => updatedBook);
  }

  void mockDeleteBook() {
    when(
      () => deleteBook(
        userId: any(named: 'userId'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
