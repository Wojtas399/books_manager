import '../../../interfaces/auth_interface.dart';

class GetLoggedUserIdUseCase {
  late final AuthInterface _authInterface;

  GetLoggedUserIdUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Stream<String?> execute() {
    return _authInterface.loggedUserId$;
  }
}
