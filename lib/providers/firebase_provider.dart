import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../firebase/services/fire_auth_service.dart';
import '../firebase/services/fire_avatar_service.dart';
import '../firebase/services/fire_user_service.dart';
import '../interfaces/auth_interface.dart';
import '../interfaces/user_interface.dart';

class FirebaseProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: FireAuthService(),
    );
  }

  static UserInterface provideUserInterface() {
    return UserRepository(
      fireUserService: FireUserService(),
      fireAvatarService: FireAvatarService(),
    );
  }
}
