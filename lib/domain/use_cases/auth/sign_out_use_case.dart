import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';

class SignOutUseCase {
  late final AuthInterface _authInterface;
  late final BookInterface _bookInterface;

  SignOutUseCase({
    required AuthInterface authInterface,
    required BookInterface bookInterface,
  }) {
    _authInterface = authInterface;
    _bookInterface = bookInterface;
  }

  Future<void> execute() async {
    await _authInterface.signOut();
    _bookInterface.dispose();
  }
}
