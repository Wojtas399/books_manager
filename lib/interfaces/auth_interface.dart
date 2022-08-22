import '../domain/entities/auth_state.dart';

abstract class AuthInterface {
  Stream<AuthState> get authState$;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});
}
