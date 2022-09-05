import 'package:app/data/data_sources/remote_db/firebase/firebase_references.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:app/data/models/db_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreBookService {
  Future<List<DbBook>> loadBooksByUserId({required String userId}) async {
    final CollectionReference<FirebaseBook> booksRef = _getUserBooksRef(userId);
    final QuerySnapshot<FirebaseBook> snapshot = await booksRef.get();
    final List<DocumentChange<FirebaseBook>> docChanges = snapshot.docChanges;
    return docChanges.map(_getDbBookFromDocChange).toList();
  }

  Future<void> addBook({required DbBook dbBook}) async {
    final CollectionReference<FirebaseBook> booksRef = _getUserBooksRef(
      dbBook.userId,
    );
    final DocumentReference<FirebaseBook> bookDocRef = booksRef.doc(
      '${dbBook.id}',
    );
    await bookDocRef.set(dbBook.toFirebaseBook());
  }

  Future<void> deleteBook({
    required String userId,
    required String bookId,
  }) async {
    final CollectionReference<DbBook> booksRef = _getUserBooksRef(userId);
    final DocumentReference<DbBook> bookRef = booksRef.doc(bookId);
    await bookRef.delete();
  }

  CollectionReference<FirebaseBook> _getUserBooksRef(String userId) {
    return FireReferences.getBooksRefWithConverter(userId: userId);
  }

  DbBook _getDbBookFromDocChange(DocumentChange<FirebaseBook> docChange) {
    final DocumentSnapshot<FirebaseBook> docSnapshot = docChange.doc;
    final FirebaseBook? firebaseBook = docSnapshot.data();
    if (firebaseBook != null) {
      return firebaseBook.copyWith(id: docSnapshot.id);
    } else {
      throw 'Cannot load book';
    }
  }
}
