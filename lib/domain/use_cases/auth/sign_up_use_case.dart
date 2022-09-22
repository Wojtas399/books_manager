import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';

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
    required String email,
    required String password,
  }) async {
    final String signedUpUserId = await _authInterface.signUp(
      email: email,
      password: password,
    );
    final User newUser = User(
      id: signedUpUserId,
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
    );
    await _userInterface.addUser(user: newUser);
  }
}
