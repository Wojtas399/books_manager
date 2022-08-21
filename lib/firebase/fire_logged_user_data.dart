import 'package:firebase_auth/firebase_auth.dart';

import 'fire_instances.dart';

class FireLoggedUserData {
  static User? get user => FireInstances.auth.currentUser;

  static String? get id => user?.uid;

  static String? get email => user?.email;
}