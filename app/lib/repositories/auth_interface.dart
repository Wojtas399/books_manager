import 'package:app/repositories/avatars/sign_up_backend_avatar_interface.dart';

abstract class AuthInterface {
  signIn({required String email, required String password});

  signUp({
    required String username,
    required String email,
    required String password,
    required SignUpBackendAvatarInterface avatar,
  });

  logOut();
}
