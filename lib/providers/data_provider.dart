import 'package:app/data/data_sources/firebase/services/firebase_auth_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_storage_image_service.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/data/repositories/day_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class DataProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      firebaseAuthService: FirebaseAuthService(),
    );
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      firebaseFirestoreUserService: FirebaseFirestoreUserService(),
    );
  }

  static BookInterface provideBookInterface() {
    return BookRepository(
      firebaseFirestoreBookService: FirebaseFirestoreBookService(),
      firebaseStorageImageService: FirebaseStorageImageService(),
    );
  }

  static DayInterface provideDayInterface() {
    return DayRepository(
      firebaseFirestoreUserService: FirebaseFirestoreUserService(),
    );
  }
}
