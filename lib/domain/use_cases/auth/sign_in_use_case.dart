import '../../../interfaces/auth_interface.dart';

class SignInUseCase {
  late final AuthInterface _authInterface;

  SignInUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Future<void> execute({
    required String email,
    required String password,
  }) async {
    await _authInterface.signIn(
      email: email,
      password: password,
    );
  }
}
