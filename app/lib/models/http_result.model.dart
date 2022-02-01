abstract class HttpResult {}

class HttpSuccess extends HttpResult {
  final String? message;

  HttpSuccess({this.message});
}

class HttpFailure extends HttpResult {
  final String? message;

  HttpFailure({this.message});
}
