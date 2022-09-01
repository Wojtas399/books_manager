import 'package:app/data/data_sources/remote_db/firebase/fire_instances.dart';
import 'package:app/data/models/db_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireReferences {
  static CollectionReference get usersRef =>
      FireInstances.firestore.collection('Users');

  static CollectionReference getBooksRef({required String userId}) {
    return usersRef.doc(userId).collection('Books');
  }

  static CollectionReference<DbBook> getBooksRefWithConverter({
    required String userId,
  }) {
    return getBooksRef(userId: userId).withConverter(
      fromFirestore: (snapshot, _) => DbBook.fromFirebaseJson(
        snapshot.data()!,
        snapshot.id,
        userId,
      ),
      toFirestore: (data, _) => data.toFirebaseJson(),
    );
  }
}
