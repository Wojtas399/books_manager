import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'avatar_service.dart';

class AuthService {
  final AvatarService _avatarService = new AvatarService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Signed in';
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    }
  }

  Future<String> signUp({
    required String username,
    required String email,
    required String password,
    required AvatarType avatarType,
    String? avatarImgFilePath,
  }) async {
    try {
      UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? userId = credential.user?.uid;
      if (userId == null) {
        throw 'Something went wrong with user registration...';
      }
      String avatarImgPathInDb = await _avatarService.saveAvatarInDb(
        type: avatarType,
        avatarImgFilePath: avatarImgFilePath,
      );
      await _firestore
          .collection('Users')
          .doc(userId)
          .set({'avatarPath': avatarImgPathInDb, 'userName': username});
      return 'Signed up';
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    }
  }

  Future<String> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return 'Successfully logged out';
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    }
  }
}
