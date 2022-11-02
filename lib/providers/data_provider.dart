import 'package:app/data/data_sources/auth_data_source.dart';
import 'package:app/data/data_sources/book_data_source.dart';
import 'package:app/data/data_sources/day_data_source.dart';
import 'package:app/data/data_sources/firebase/services/firebase_auth_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_storage_service.dart';
import 'package:app/data/data_sources/user_data_source.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/data/repositories/day_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class DataProvider {
  static AuthInterface provideAuthInterface() {
    return AuthDataSource(
      firebaseAuthService: FirebaseAuthService(),
    );
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      userDataSource: _provideUserDataSource(),
    );
  }

  static BookInterface provideBookInterface() {
    return BookRepository(
      bookDataSource: _provideBookDataSource(),
    );
  }

  static DayInterface provideDayInterface() {
    return DayRepository(
      dayDataSource: _provideDayDataSource(),
    );
  }

  static UserDataSource _provideUserDataSource() {
    return UserDataSource(
      firebaseFirestoreUserService: FirebaseFirestoreUserService(),
    );
  }

  static BookDataSource _provideBookDataSource() {
    return BookDataSource(
      firebaseFirestoreBookService: FirebaseFirestoreBookService(),
      firebaseStorageService: FirebaseStorageService(),
    );
  }

  static DayDataSource _provideDayDataSource() {
    return DayDataSource(
      firebaseFirestoreUserService: FirebaseFirestoreUserService(),
    );
  }
}
