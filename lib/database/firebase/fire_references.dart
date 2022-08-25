import 'package:cloud_firestore/cloud_firestore.dart';

import 'fire_instances.dart';
import 'fire_logged_user_data.dart';

class FireReferences {
  static CollectionReference get usersRef =>
      FireInstances.firestore.collection('Users');

  static DocumentReference get loggedUserRef => usersRef.doc(
        FireLoggedUserData.id,
      );
}
