import 'package:app/domain/interfaces/auth_interface.dart';

class ChangeLoggedUserPasswordUseCase {
  late final AuthInterface _authInterface;

  ChangeLoggedUserPasswordUseCase({
    required AuthInterface authInterface,
  }) {
    _authInterface = authInterface;
  }

  Future<void> execute({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authInterface.changeLoggedUserPassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
