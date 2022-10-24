import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class SignOutUseCase {
  late final AuthInterface _authInterface;
  late final UserInterface _userInterface;

  SignOutUseCase({
    required AuthInterface authInterface,
    required UserInterface userInterface,
  }) {
    _authInterface = authInterface;
    _userInterface = userInterface;
  }

  Future<void> execute() async {
    _userInterface.reset();
    await _authInterface.signOut();
  }
}
