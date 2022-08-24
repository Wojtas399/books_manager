import 'package:equatable/equatable.dart';

abstract class CustomError extends Equatable {
  final String code;

  const CustomError({required this.code});

  @override
  List<Object> get props => [code];
}

class AuthError extends CustomError {
  AuthError({required AuthErrorCode authErrorCode})
      : super(code: authErrorCode.name);
}

class NetworkError extends CustomError {
  NetworkError({required NetworkErrorCode networkErrorCode})
      : super(code: networkErrorCode.name);
}

enum AuthErrorCode {
  invalidEmail,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  unknown,
}

enum NetworkErrorCode {
  lossOfConnection,
}
