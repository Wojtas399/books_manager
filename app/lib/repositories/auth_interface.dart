import 'avatar_interface.dart';

abstract class AuthInterface {
  signIn({required String email, required String password});

  signUp({
    required String username,
    required String email,
    required String password,
    required AvatarInterface avatar,
  });

  logOut();
}
