import 'package:app/data/data_sources/firebase/entities/firebase_book.dart';
import 'package:app/data/data_sources/firebase/firebase_references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreBookService {
  Stream<FirebaseBook?> getBook({
    required String bookId,
    required String userId,
  }) {
    final DocumentReference<FirebaseBook> bookRef = _getBookRef(bookId, userId);
    return bookRef
        .snapshots()
        .map((DocumentSnapshot<FirebaseBook> snapshot) => snapshot.data());
  }

  Stream<List<FirebaseBook>> getUserBooks({
    required String userId,
    String? bookStatus,
  }) {
    final CollectionReference<FirebaseBook> booksRef = _getUserBooksRef(userId);
    Stream<QuerySnapshot<FirebaseBook>> snapshots = booksRef.snapshots();
    if (bookStatus != null) {
      snapshots = booksRef
          .where(FirebaseBookFields.status, isEqualTo: bookStatus)
          .snapshots();
    }
    return snapshots.map(_getBooksFromSnapshot);
  }

  Future<void> addBook({
    required String userId,
    required String status,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
    required String? imageFileName,
  }) async {
    final CollectionReference<FirebaseBook> userBooksRef =
        _getUserBooksRef(userId);
    await userBooksRef.add(
      FirebaseBook(
        id: '',
        userId: userId,
        status: status,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
        imageFileName: imageFileName,
      ),
    );
  }

  Future<void> updateBook({
    required String bookId,
    required String userId,
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    String? imageFileName,
    bool deletedImageFileName = false,
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
        imageFileName: imageFileName,
        deletedImageFileName: deletedImageFileName,
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

  List<FirebaseBook> _getBooksFromSnapshot(
    QuerySnapshot<FirebaseBook> snapshot,
  ) {
    final List<QueryDocumentSnapshot<FirebaseBook>> docs = snapshot.docs;
    return docs.map(
      (QueryDocumentSnapshot<FirebaseBook> docSnapshot) {
        return docSnapshot.data();
      },
    ).toList();
  }
}
