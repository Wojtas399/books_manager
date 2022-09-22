import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/models/db_book.dart';
import 'package:mocktail/mocktail.dart';

class FakeDbBook extends Fake implements DbBook {}

class MockBookLocalDbService extends Mock implements BookLocalDbService {
  void mockLoadUserBooks({required List<DbBook> dbBooks}) {
    _mockSyncState();
    when(
      () => loadUserBooks(
        userId: any(named: 'userId'),
        bookStatus: any(named: 'bookStatus'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => dbBooks);
  }

  void mockAddBook() {
    registerFallbackValue(FakeDbBook());
    _mockSyncState();
    when(
      () => addBook(
        dbBook: any(named: 'dbBook'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBookData({required DbBook dbBook}) {
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
    ).thenAnswer((_) async => dbBook);
  }

  void mockUpdateBookImage({required DbBook dbBook}) {
    when(
      () => updateBookImage(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
        imageData: any(named: 'imageData'),
      ),
    ).thenAnswer((_) async => dbBook);
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
