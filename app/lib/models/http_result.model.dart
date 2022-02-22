import 'package:equatable/equatable.dart';

abstract class HttpResult extends Equatable {
  late final String? _message;

  HttpResult(String? message) {
    _message = message;
  }

  String? getMessage() {
    return _message;
  }

  @override
  List<Object> get props => [_message ?? ''];
}

class HttpSuccess extends HttpResult {
  HttpSuccess({String? message}) : super(message);
}

class HttpFailure extends HttpResult {
  HttpFailure({String? message}) : super(message);
}
