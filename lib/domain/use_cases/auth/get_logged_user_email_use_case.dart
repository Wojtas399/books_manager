import 'package:app/domain/interfaces/auth_interface.dart';

class GetLoggedUserEmailUseCase {
  late final AuthInterface _authInterface;

  GetLoggedUserEmailUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Stream<String?> execute() {
    return _authInterface.loggedUserEmail$;
  }
}
