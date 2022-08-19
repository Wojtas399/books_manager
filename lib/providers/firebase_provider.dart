import '../domain/repositories/auth_repository.dart';
import '../firebase/services/fire_auth_service.dart';
import '../interfaces/auth_interface.dart';

class FirebaseProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(
      fireAuthService: FireAuthService(),
    );
  }
}
