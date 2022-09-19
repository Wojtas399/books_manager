import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';

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
    if (loggedUserId != null) {
      await _bookInterface.deleteAllUserBooks(userId: loggedUserId);
      await _userInterface.deleteUser(userId: loggedUserId);
      await _authInterface.deleteLoggedUser(password: password);
    }
  }
}
