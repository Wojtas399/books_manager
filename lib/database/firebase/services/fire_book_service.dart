import 'package:cloud_firestore/cloud_firestore.dart';

import '../../entities/db_book.dart';
import '../fire_references.dart';

class FirebaseBookService {
  Future<List<DbBook>> loadBooksByUserId({required String userId}) async {
    final QuerySnapshot<DbBook> snapshot =
        await FireReferences.getBooksRefWithConverter(userId: userId).get();
    final List<DocumentChange<DbBook>> docChanges = snapshot.docChanges;
    return docChanges.map(_getDbBookFromDocChange).toList();
  }

  Future<void> addNewBook(DbBook dbBook) async {
    await FireReferences.getBooksRefWithConverter(userId: dbBook.userId)
        .doc('${dbBook.id}')
        .set(dbBook);
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
