import 'package:app/config/errors.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/models/error.dart';

class DeleteLoggedUserUseCase {
  late final BookInterface _bookInterface;
  late final UserInterface _userInterface;
  late final AuthInterface _authInterface;

  DeleteLoggedUserUseCase({
    required BookInterface bookInterface,
    required UserInterface userInterface,
    required AuthInterface authInterface,
  }) {
    _bookInterface = bookInterface;
    _userInterface = userInterface;
    _authInterface = authInterface;
  }

  Future<void> execute({required String password}) async {
    final String? loggedUserId = await _authInterface.loggedUserId$.first;
    if (loggedUserId == null) {
      throw const AuthError(code: AuthErrorCode.userNotFound);
    }
    final bool isPasswordCorrect = await _authInterface
        .checkLoggedUserPasswordCorrectness(password: password);
    if (!isPasswordCorrect) {
      throw const AuthError(code: AuthErrorCode.wrongPassword);
    }
    await _bookInterface.deleteAllUserBooks(userId: loggedUserId);
    await _userInterface.deleteUser(userId: loggedUserId);
    await _authInterface.deleteLoggedUser(password: password);
  }
}
