import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeFirebaseBook extends Fake implements FirebaseBook {}

class MockFirebaseFirestoreBookService extends Mock
    implements FirebaseFirestoreBookService {
  void mockLoadUserBooks({required List<FirebaseBook> userFirebaseBooks}) {
    when(
      () => loadUserBooks(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => userFirebaseBooks);
  }

  void mockAddBook() {
    _mockFirebaseBook();
    when(
      () => addBook(
        firebaseBook: any(named: 'firebaseBook'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBook() {
    when(
      () => updateBook(
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

  void mockDeleteBook() {
    when(
      () => deleteBook(
        userId: any(named: 'userId'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockFirebaseBook() {
    registerFallbackValue(FakeFirebaseBook());
  }
}
