import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthStateSignedIn extends AuthState {
  final String userId;

  const AuthStateSignedIn({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AuthStateSignedOut extends AuthState {
  const AuthStateSignedOut();
}
