import 'package:app/models/operation_result.model.dart';
import 'package:app/repositories/auth/auth_interface.dart';

class AuthBloc {
  late AuthInterface _authInterface;

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
      yield HttpFailure();
    }
  }
}
