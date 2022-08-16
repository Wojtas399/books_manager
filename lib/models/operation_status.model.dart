import 'package:equatable/equatable.dart';

abstract class OperationStatus extends Equatable {
  const OperationStatus();
}

class InitialStatusOfOperation extends OperationStatus {
  const InitialStatusOfOperation();

  @override
  List<Object> get props => [];
}

class OperationLoading extends OperationStatus {
  @override
  List<Object> get props => [];
}

class OperationSuccessful extends OperationStatus {
  @override
  List<Object> get props => [];
}

class OperationFailed extends OperationStatus {
  final String errorMessage;

  OperationFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
