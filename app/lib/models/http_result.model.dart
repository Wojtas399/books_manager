import 'package:equatable/equatable.dart';

abstract class HttpResult extends Equatable {}

class HttpSuccess extends HttpResult {
  final String? message;

  HttpSuccess({this.message});

  @override
  List<Object> get props => [];
}

class HttpFailure extends HttpResult {
  final String? message;

  HttpFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}
