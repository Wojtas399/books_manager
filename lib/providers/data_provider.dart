import 'package:app/data/data_sources/book_data_source.dart';
import 'package:app/data/data_sources/day_data_source.dart';
import 'package:app/data/data_sources/firebase/services/firebase_auth_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_storage_service.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/providers/device_provider.dart';

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
    return BookDataSource(
      firebaseFirestoreBookService: FirebaseFirestoreBookService(),
      firebaseStorageService: FirebaseStorageService(),
      device: DeviceProvider.provide(),
    );
  }

  static DayInterface provideDayInterface() {
    return DayDataSource(
      firebaseFirestoreUserService: FirebaseFirestoreUserService(),
    );
  }
}
