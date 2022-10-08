import 'package:app/data/data_sources/remote_db/firebase/firebase_references.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreBookService {
  Future<List<FirebaseBook>> loadUserBooks({
    required String userId,
  }) async {
    final CollectionReference<FirebaseBook> booksRef = _getUserBooksRef(userId);
    final QuerySnapshot<FirebaseBook> snapshot = await booksRef.get();
    final List<DocumentChange<FirebaseBook>> docChanges = snapshot.docChanges;
    return docChanges.map(_getDataFromDocChange).toList();
  }

  Future<void> addBook({required FirebaseBook firebaseBook}) async {
    final DocumentReference<FirebaseBook> bookRef = _getBookRef(
      firebaseBook.id,
      firebaseBook.userId,
    );
    await bookRef.set(firebaseBook);
  }

  Future<void> updateBook({
    required String bookId,
    required String userId,
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) async {
    final DocumentReference<FirebaseBook> bookRef = _getBookRef(bookId, userId);
    final DocumentSnapshot<FirebaseBook> snapshot = await bookRef.get();
    final FirebaseBook? firebaseBook = snapshot.data();
    if (firebaseBook != null) {
      final FirebaseBook updatedFirebaseBook = firebaseBook.copyWith(
        status: status,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );
      await bookRef.set(updatedFirebaseBook);
    } else {
      throw 'Cannot load book from firebase';
    }
  }

  Future<void> deleteBook({
    required String userId,
    required String bookId,
  }) async {
    final DocumentReference<FirebaseBook> bookRef = _getBookRef(bookId, userId);
    await bookRef.delete();
  }

  DocumentReference<FirebaseBook> _getBookRef(String? bookId, String userId) {
    final CollectionReference<FirebaseBook> booksRef = _getUserBooksRef(userId);
    return booksRef.doc(bookId);
  }

  CollectionReference<FirebaseBook> _getUserBooksRef(String userId) {
    return FireReferences.getBooksRefWithConverter(userId: userId);
  }

  FirebaseBook _getDataFromDocChange(DocumentChange<FirebaseBook> docChange) {
    final DocumentSnapshot<FirebaseBook> docSnapshot = docChange.doc;
    final FirebaseBook? firebaseBook = docSnapshot.data();
    if (firebaseBook != null) {
      return firebaseBook;
    } else {
      throw 'Cannot load book';
    }
  }
}
