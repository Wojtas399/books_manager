import '../../../interfaces/auth_interface.dart';

class SignOutUseCase {
  late final AuthInterface _authInterface;

  SignOutUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Future<void> execute() async {
    await _authInterface.signOut();
  }
}