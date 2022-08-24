import '../../../interfaces/auth_interface.dart';
import '../../../models/auth_state.dart';

class GetAuthStateUseCase {
  late final AuthInterface _authInterface;

  GetAuthStateUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Stream<AuthState> execute() {
    return _authInterface.authState$;
  }
}