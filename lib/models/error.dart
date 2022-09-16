import 'package:app/config/errors.dart';
import 'package:equatable/equatable.dart';

abstract class CustomError<T> extends Equatable {
  final T code;

  const CustomError({required this.code});

  @override
  List<T> get props => [code];
}

class AuthError extends CustomError<AuthErrorCode> {
  const AuthError({required super.code});
}

class NetworkError extends CustomError<NetworkErrorCode> {
  const NetworkError({required super.code});
}

class BookError extends CustomError<BookErrorCode> {
  const BookError({required super.code});
}
