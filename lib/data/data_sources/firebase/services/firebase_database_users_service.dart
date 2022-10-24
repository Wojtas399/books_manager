import 'dart:convert';

import 'package:app/data/data_sources/firebase/entities/firebase_user.dart';
import 'package:app/data/data_sources/firebase/firebase_references.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseUsersService {
  Stream<FirebaseUser?> getUserStream({required String userId}) {
    return _getUserRef(userId).onValue.map(_getUserFromEvent);
  }

  Future<void> addUser({required FirebaseUser firebaseUser}) async {
    final DatabaseReference userRef = _getUserRef(firebaseUser.id);
    await userRef.set(
      firebaseUser.toJson(),
    );
  }

  Future<FirebaseUser> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    final FirebaseUser? user = await getUserStream(userId: userId).first;
    if (user == null) {
      throw '(FirebaseDatabaseUsersService) Cannot find user to do update operation';
    }
    final FirebaseUser updatedUser = user.copyWith(
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
    final DatabaseReference userRef = _getUserRef(userId);
    await userRef.update(
      updatedUser.toJson(),
    );
    return updatedUser;
  }

  Future<void> deleteUser({required String userId}) async {
    final DatabaseReference userRef = _getUserRef(userId);
    await userRef.remove();
  }

  DatabaseReference _getUserRef(String userId) {
    return FirebaseReferences.getUserRef(userId: userId);
  }

  FirebaseUser? _getUserFromEvent(DatabaseEvent event) {
    final String? userId = event.snapshot.key;
    final Object? userObject = event.snapshot.value;
    if (userId != null && userObject != null) {
      final Map<String, Object?> userJson = _mapObjectToJson(userObject);
      return FirebaseUser.fromJson(
        userId: userId,
        json: userJson,
      );
    }
    return null;
  }

  Map<String, Object?> _mapObjectToJson(Object object) {
    final String jsonString = jsonEncode(object);
    return jsonDecode(jsonString);
  }
}
