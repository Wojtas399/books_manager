import 'package:app/models/http_result.model.dart';
import 'package:app/interfaces/auth_interface.dart';
import 'package:app/interfaces/avatar_interface.dart';

class AuthBloc {
  late final AuthInterface _authInterface;

  AuthBloc({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Stream<HttpResult> signIn({
    required String email,
    required String password,
  }) async* {
    try {
      await _authInterface.signIn(email: email, password: password);
      yield HttpSuccess();
    } catch (error) {
      yield HttpFailure(message: error.toString());
    }
  }

  Stream<HttpResult> signUp({
    required String username,
    required String email,
    required String password,
    required AvatarInterface avatar,
  }) async* {
    try {
      await _authInterface.signUp(
        username: username,
        email: email,
        password: password,
        avatar: avatar,
      );
      yield HttpSuccess();
    } catch (error) {
      yield HttpFailure(message: error.toString());
    }
  }

  signOut() async {
    await _authInterface.logOut();
  }
}
