import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities/fire_user.dart';
import 'fire_instances.dart';
import 'fire_logged_user_data.dart';

class FireReferences {
  static CollectionReference get usersRef =>
      FireInstances.firestore.collection('Users');

  static DocumentReference get loggedUserRef => usersRef.doc(
        FireLoggedUserData.id,
      );

  static CollectionReference get usersRefWithConverter =>
      usersRef.withConverter<FireUser>(
        fromFirestore: (snapshot, _) => FireUser.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (user, _) => user.toJson(),
      );

  static DocumentReference<FireUser> get loggedUserRefWithConverter =>
      loggedUserRef.withConverter<FireUser>(
        fromFirestore: (snapshot, _) => FireUser.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (settings, _) => settings.toJson(),
      );
}
