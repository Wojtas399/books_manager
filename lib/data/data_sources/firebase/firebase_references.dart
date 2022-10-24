import 'package:app/data/data_sources/firebase/firebase_instances.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseReferences {
  static DatabaseReference getUserRef({required String userId}) {
    return FirebaseInstances.database.ref('Users/$userId');
  }
}
