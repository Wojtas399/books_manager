import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/db_book.dart';
import 'fire_instances.dart';

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
