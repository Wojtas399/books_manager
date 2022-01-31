abstract class OperationResult {}

class OperationResultSuccess extends OperationResult {
  final String? message;

  OperationResultSuccess({this.message});
}

class OperationResultFailure extends OperationResult {
  final String? message;

  OperationResultFailure({this.message});
}
