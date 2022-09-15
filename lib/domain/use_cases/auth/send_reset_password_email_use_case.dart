import 'package:app/domain/interfaces/auth_interface.dart';

class SendResetPasswordEmailUseCase {
  late final AuthInterface _authInterface;

  SendResetPasswordEmailUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Future<void> execute({required String email}) async {
    await _authInterface.sendPasswordResetEmail(email: email);
  }
}
