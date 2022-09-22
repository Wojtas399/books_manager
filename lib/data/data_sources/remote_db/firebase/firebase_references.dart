import 'package:app/data/data_sources/remote_db/firebase/firebase_instances.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireReferences {
  static CollectionReference get usersRef =>
      FireInstances.firestore.collection('Users');

  static CollectionReference getBooksRef({required String userId}) {
    return usersRef.doc(userId).collection('Books');
  }

  static CollectionReference<FirebaseUser> getUsersRefWithConverter() {
    return usersRef.withConverter(
      fromFirestore: (snapshot, _) => FirebaseUser.fromJson(
        json: snapshot.data()!,
        userId: snapshot.id,
      ),
      toFirestore: (FirebaseUser firebaseUser, _) => firebaseUser.toJson(),
    );
  }

  static CollectionReference<FirebaseBook> getBooksRefWithConverter({
    required String userId,
  }) {
    return getBooksRef(userId: userId).withConverter(
      fromFirestore: (snapshot, _) => FirebaseBook.fromJson(
        json: snapshot.data()!,
        userId: userId,
        bookId: snapshot.id,
      ),
      toFirestore: (FirebaseBook firebaseBook, _) => firebaseBook.toJson(),
    );
  }
}
