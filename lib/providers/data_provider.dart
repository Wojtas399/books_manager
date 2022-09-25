import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/shared_preferences_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_user_service.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_auth_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/id_generator.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:app/data/synchronizers/user_synchronizer.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/providers/date_provider.dart';
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

  static UserInterface provideUserInterface() {
    return UserRepository(
      userSynchronizer: UserSynchronizer(
        userLocalDbService: _provideUserLocalDbService(),
        userRemoteDbService: _provideUserRemoteDbService(),
      ),
      userLocalDbService: _provideUserLocalDbService(),
      userRemoteDbService: _provideUserRemoteDbService(),
      device: DeviceProvider.provide(),
    );
  }

  static BookInterface provideBookInterface() {
    return BookRepository(
      bookSynchronizer: BookSynchronizer(
        bookLocalDbService: _provideBookLocalDbService(),
        bookRemoteDbService: _provideBookRemoteDbService(),
      ),
      bookLocalDbService: _provideBookLocalDbService(),
      bookRemoteDbService: _provideBookRemoteDbService(),
      device: DeviceProvider.provide(),
      idGenerator: IdGenerator(),
    );
  }

  static UserLocalDbService _provideUserLocalDbService() {
    return UserLocalDbService(
      sqliteUserService: SqliteUserService(),
    );
  }

  static UserRemoteDbService _provideUserRemoteDbService() {
    return UserRemoteDbService(
      firebaseFirestoreUserService: FirebaseFirestoreUserService(),
      dateProvider: DateProvider(),
    );
  }

  static BookLocalDbService _provideBookLocalDbService() {
    return BookLocalDbService(
      sqliteBookService: SqliteBookService(),
      localStorageService: LocalStorageService(),
    );
  }

  static BookRemoteDbService _provideBookRemoteDbService() {
    return BookRemoteDbService(
      firebaseFirestoreBookService: FirebaseFirestoreBookService(),
      firebaseStorageService: FirebaseStorageService(),
    );
  }
}
