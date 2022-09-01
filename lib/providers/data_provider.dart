import 'package:app/data/data_sources/local_db/local_storage/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/services/auth_local_db_service.dart';
import 'package:app/data/data_sources/local_db/services/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/shared_preferences/shared_preferences_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/fire_auth_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/fire_book_service.dart';
import 'package:app/data/data_sources/remote_db/services/auth_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/services/book_remote_db_service.dart';
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
        fireAuthService: FireAuthService(),
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
        firebaseBookService: FirebaseBookService(),
      ),
      device: DeviceProvider.provide(),
    );
  }
}
