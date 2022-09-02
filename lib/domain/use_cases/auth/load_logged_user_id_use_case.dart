import '../../../interfaces/auth_interface.dart';

class LoadLoggedUserIdUseCase {
  late final AuthInterface _authInterface;

  LoadLoggedUserIdUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Future<void> execute() async {
    await _authInterface.loadLoggedUserId();
  }
}
