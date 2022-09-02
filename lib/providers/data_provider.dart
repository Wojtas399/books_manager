import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/shared_preferences_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_auth_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/interfaces/auth_interface.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:app/providers/device_provider.dart';

class DataProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      authLocalDbService: AuthLocalDbService(
        sharedPreferencesService: SharedPreferencesService(),
      ),
      authRemoteDbService: AuthRemoteDbService(
        firebaseAuthService: FirebaseAuthService(),
      ),
    );
  }

  static BookInterface provideBookInterface() {
    return BookRepository(
      bookLocalDbService: BookLocalDbService(
        sqliteBookService: SqliteBookService(),
        localStorageService: LocalStorageService(),
      ),
      bookRemoteDbService: BookRemoteDbService(
        firebaseFirestoreBookService: FirebaseFirestoreBookService(),
        firebaseStorageService: FirebaseStorageService(),
      ),
      device: DeviceProvider.provide(),
    );
  }
}