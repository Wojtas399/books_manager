import '../database/firebase/services/fire_auth_service.dart';
import '../database/firebase/services/fire_avatar_service.dart';
import '../database/firebase/services/fire_user_service.dart';
import '../database/shared_preferences/shared_preferences_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../interfaces/auth_interface.dart';
import '../interfaces/user_interface.dart';

class DatabaseProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: FireAuthService(),
      sharedPreferencesService: SharedPreferencesService(),
    );
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      fireUserService: FireUserService(),
      fireAvatarService: FireAvatarService(),
    );
  }
}
