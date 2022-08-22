import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/user_interface.dart';
import '../../../models/avatar.dart';

class SignUpUseCase {
  late final AuthInterface _authInterface;
  late final UserInterface _userInterface;

  SignUpUseCase({
    required AuthInterface authInterface,
    required UserInterface userInterface,
  }) {
    _authInterface = authInterface;
    _userInterface = userInterface;
  }

  Future<void> execute({
    required Avatar avatar,
    required String username,
    required String email,
    required String password,
  }) async {
    await _authInterface.signUp(
      email: email,
      password: password,
    );
    await _userInterface.setUserData(
      username: username,
      avatar: avatar,
    );
  }
}
