import 'package:app/data/data_sources/remote_db/firebase/firebase_references.dart';
import 'package:app/data/models/db_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreBookService {
  Future<List<DbBook>> loadBooksByUserId({required String userId}) async {
    final CollectionReference<DbBook> booksRef = _getUserBooksRef(userId);
    final QuerySnapshot<DbBook> snapshot = await booksRef.get();
    final List<DocumentChange<DbBook>> docChanges = snapshot.docChanges;
    return docChanges.map(_getDbBookFromDocChange).toList();
  }

  Future<void> addBook({required DbBook dbBook}) async {
    final CollectionReference<DbBook> booksRef = _getUserBooksRef(
      dbBook.userId,
    );
    final DocumentReference<DbBook> bookDocRef = booksRef.doc('${dbBook.id}');
    await bookDocRef.set(dbBook);
  }

  CollectionReference<DbBook> _getUserBooksRef(String userId) {
    return FireReferences.getBooksRefWithConverter(userId: userId);
  }

  DbBook _getDbBookFromDocChange(DocumentChange<DbBook> docChange) {
    final DocumentSnapshot<DbBook> docSnapshot = docChange.doc;
    final DbBook? dbBook = docSnapshot.data();
    if (dbBook != null) {
      return dbBook.copyWith(id: docSnapshot.id);
    } else {
      throw 'Cannot load book';
    }
  }
}
