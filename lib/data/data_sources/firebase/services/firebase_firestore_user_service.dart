import 'package:app/data/data_sources/firebase/entities/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/firebase/firebase_references.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreUserService {
  Stream<FirebaseUser?> getUser({required String userId}) {
    final DocumentReference<FirebaseUser> docRef = _getUserRef(userId);
    return docRef
        .snapshots()
        .map((DocumentSnapshot<FirebaseUser> snapshot) => snapshot.data());
  }

  Future<void> addUser({required FirebaseUser firebaseUser}) async {
    final DocumentReference<FirebaseUser> docRef = _getUserRef(firebaseUser.id);
    await docRef.set(firebaseUser);
  }

  Future<void> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    List<FirebaseDay>? daysOfReading,
  }) async {
    final DocumentReference<FirebaseUser> docRef = _getUserRef(userId);
    final DocumentSnapshot<FirebaseUser> docSnapshot = await docRef.get();
    final FirebaseUser? firebaseUser = docSnapshot.data();
    if (firebaseUser != null) {
      final FirebaseUser updatedFirebaseUser = firebaseUser.copyWith(
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        daysOfReading: daysOfReading,
      );
      await docRef.set(updatedFirebaseUser);
    } else {
      throw 'Cannot load user from firebase';
    }
  }

  Future<void> deleteUser({required String userId}) async {
    final DocumentReference userRef = _getUserRef(userId);
    await userRef.delete();
  }

  DocumentReference<FirebaseUser> _getUserRef(String userId) {
    return FireReferences.getUsersRefWithConverter().doc(userId);
  }
}
