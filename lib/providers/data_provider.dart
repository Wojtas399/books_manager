import 'package:app/data/data_sources/firebase/services/firebase_database_users_service.dart';
import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/shared_preferences_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_book_service.dart';
import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_auth_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/data_sources/users_data_source.dart';
import 'package:app/data/id_generator.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/data/repositories/day_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:app/data/synchronizers/day_synchronizer.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
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
      usersDataSource: _provideUsersDataSource(),
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

  static DayInterface provideDayInterface() {
    return DayRepository(
      daySynchronizer: DaySynchronizer(
        dayLocalDbService: _provideDayLocalDbService(),
        dayRemoteDbService: _provideDayRemoteDbService(),
      ),
      dayLocalDbService: _provideDayLocalDbService(),
      dayRemoteDbService: _provideDayRemoteDbService(),
      device: DeviceProvider.provide(),
    );
  }

  static UsersDataSource _provideUsersDataSource() {
    return UsersDataSource(
      firebaseDatabaseUsersService: FirebaseDatabaseUsersService(),
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

  static DayLocalDbService _provideDayLocalDbService() {
    return DayLocalDbService(
      sqliteReadBookService: SqliteReadBookService(),
    );
  }

  static DayRemoteDbService _provideDayRemoteDbService() {
    return DayRemoteDbService(
      firebaseFirestoreUserService: FirebaseFirestoreUserService(),
    );
  }
}
