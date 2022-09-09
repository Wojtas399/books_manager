import 'package:app/domain/interfaces/auth_interface.dart';

class DeleteUserUseCase {
  late final AuthInterface _authInterface;

  DeleteUserUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Future<void> execute({required String password}) async {
    await _authInterface.deleteLoggedUser(password: password);
  }
}
