import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/fire_instances.dart';
import 'package:app/data/data_sources/remote_db/firebase/fire_references.dart';
import 'package:app/data/models/db_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseBookService {
  Future<List<DbBook>> loadBooksByUserId({required String userId}) async {
    final CollectionReference<DbBook> booksRef = _getUserBooksRef(userId);
    final QuerySnapshot<DbBook> snapshot = await booksRef.get();
    final List<DocumentChange<DbBook>> docChanges = snapshot.docChanges;
    return docChanges.map(_getDbBookFromDocChange).toList();
  }

  Future<Uint8List?> loadBookImageData({
    required String userId,
    required String bookId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, bookId);
    try {
      return await _tryLoadImageData(imageRef);
    } catch (_) {
      return null;
    }
  }

  Future<void> addBook({required DbBook dbBook}) async {
    final String userId = dbBook.userId;
    final String? bookId = dbBook.id;
    final Uint8List? imageData = dbBook.imageData;
    final CollectionReference<DbBook> booksRef = _getUserBooksRef(userId);
    final DocumentReference<DbBook> bookDocRef = booksRef.doc('${dbBook.id}');
    await bookDocRef.set(dbBook);
    if (bookId != null && imageData != null) {
      await _addImageToStorage(imageData, dbBook.userId, bookId);
    }
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

  Reference _getBookImageReference(String userId, String bookId) {
    return FireInstances.storage.ref('$userId/books/$bookId.jpg');
  }

  Future<Uint8List?> _tryLoadImageData(Reference imageRef) async {
    return await imageRef.getData();
  }

  Future<void> _addImageToStorage(
    Uint8List imageData,
    String userId,
    String bookId,
  ) async {
    final Reference imageRef = _getBookImageReference(userId, bookId);
    await imageRef.putData(imageData);
  }
}
