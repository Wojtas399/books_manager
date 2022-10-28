import 'package:app/data/data_sources/firebase/entities/firebase_book.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_book_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeFirebaseBook extends Fake implements FirebaseBook {}

class MockFirebaseFirestoreBookService extends Mock
    implements FirebaseFirestoreBookService {
  void mockGetBook({FirebaseBook? firebaseBook}) {
    when(
      () => getBook(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(firebaseBook));
  }

  void mockGetUserBooks({required List<FirebaseBook> userFirebaseBooks}) {
    when(
      () => getUserBooks(
        userId: any(named: 'userId'),
        bookStatus: any(named: 'bookStatus'),
      ),
    ).thenAnswer((_) => Stream.value(userFirebaseBooks));
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
}
