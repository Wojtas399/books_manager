import 'package:app/data/firebase/entities/firebase_book.dart';
import 'package:app/data/firebase/entities/firebase_doc_change.dart';
import 'package:app/data/firebase/services/firebase_firestore_book_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeFirebaseBook extends Fake implements FirebaseBook {}

class MockFirebaseFirestoreBookService extends Mock
    implements FirebaseFirestoreBookService {
  void mockGetDocChangesOfAllBooksOfUser({
    required List<FirebaseDocChange<FirebaseBook>> docChanges,
  }) {
    when(
      () => getDocChangesOfAllBooksOfUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(docChanges));
  }

  void mockLoadAllBooksOfUser({required List<FirebaseBook> allUserBooks}) {
    when(
      () => loadAllBooksOfUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => allUserBooks);
  }

  void mockLoadBookImageFileName({String? bookImageFileName}) {
    when(
      () => loadBookImageFileName(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => bookImageFileName);
  }

  void mockAddBook() {
    when(
      () => addBook(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
        imageFileName: any(named: 'imageFileName'),
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
        imageFileName: any(named: 'imageFileName'),
        deletedImageFileName: any(named: 'deletedImageFileName'),
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

  void mockDeleteAllBooksOfUser() {
    when(
      () => deleteAllBooksOfUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
