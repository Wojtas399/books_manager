import '../../../interfaces/auth_interface.dart';

class SignUpUseCase {
  late final AuthInterface _authInterface;

  SignUpUseCase({
    required AuthInterface authInterface,
  }) {
    _authInterface = authInterface;
  }

  Future<void> execute({
    required String email,
    required String password,
  }) async {
    await _authInterface.signUp(
      email: email,
      password: password,
    );
  }
}
