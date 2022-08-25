import '../database/firebase/services/fire_auth_service.dart';
import '../database/shared_preferences/shared_preferences_service.dart';
import '../database/sqlite/services/sqlite_book_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/book_repository.dart';
import '../interfaces/auth_interface.dart';
import '../interfaces/book_interface.dart';

class DatabaseProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: FireAuthService(),
      sharedPreferencesService: SharedPreferencesService(),
    );
  }

  static BookInterface provideBookInterface() {
    return BookRepository(
      sqliteBookService: SqliteBookService(),
    );
  }
}
