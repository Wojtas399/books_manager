import 'package:app/data/firebase/entities/firebase_book.dart';
import 'package:app/data/firebase/entities/firebase_doc_change.dart';
import 'package:app/data/firebase/firebase_instances.dart';
import 'package:app/data/firebase/firebase_references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreBookService {
  Stream<List<FirebaseDocChange<FirebaseBook>>> getDocChangesOfAllBooksOfUser({
    required String userId,
  }) {
    final CollectionReference<FirebaseBook> booksRef =
        _getBooksOfUserRef(userId);
    return booksRef.snapshots().map((snapshots) => snapshots.docChanges).map(
          (docChanges) => docChanges.map(_createFirebaseDocChange).toList(),
        );
  }

  Future<List<FirebaseBook>> loadAllBooksOfUser({
    required String userId,
  }) async {
    final CollectionReference<FirebaseBook> booksRef =
        _getBooksOfUserRef(userId);
    final QuerySnapshot<FirebaseBook> snapshot = await booksRef.get();
    final List<QueryDocumentSnapshot<FirebaseBook>> docs = snapshot.docs;
    return docs.map(
      (QueryDocumentSnapshot<FirebaseBook> docSnapshot) {
        return docSnapshot.data();
      },
    ).toList();
  }

  Future<String?> loadBookImageFileName({
    required String bookId,
    required String userId,
  }) async {
    final DocumentReference<FirebaseBook> docRef = _getBookRef(bookId, userId);
    final DocumentSnapshot<FirebaseBook> snapshot = await docRef.get();
    final FirebaseBook? firebaseBook = snapshot.data();
    return firebaseBook?.imageFileName;
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
        _getBooksOfUserRef(userId);
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

  Future<void> deleteAllBooksOfUser({required String userId}) async {
    final CollectionReference<FirebaseBook> booksRef =
        _getBooksOfUserRef(userId);
    final WriteBatch batch = FireInstances.firestore.batch();
    final snapshots = await booksRef.get();
    for (final docSnapshot in snapshots.docs) {
      batch.delete(docSnapshot.reference);
    }
    await batch.commit();
  }

  DocumentReference<FirebaseBook> _getBookRef(String? bookId, String userId) {
    final CollectionReference<FirebaseBook> booksRef =
        _getBooksOfUserRef(userId);
    return booksRef.doc(bookId);
  }

  CollectionReference<FirebaseBook> _getBooksOfUserRef(String userId) {
    return FireReferences.getBooksRefWithConverter(userId: userId);
  }

  FirebaseDocChange<FirebaseBook> _createFirebaseDocChange(
    DocumentChange<FirebaseBook> docChange,
  ) {
    return FirebaseDocChange<FirebaseBook>(
      docChangeType: docChange.type,
      doc: docChange.doc.data(),
    );
  }
}
