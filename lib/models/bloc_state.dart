import 'package:equatable/equatable.dart';

import 'bloc_status.dart';

abstract class BlocState extends Equatable {
  final BlocStatus status;

  const BlocState({required this.status});

  @override
  List<Object> get props => [status];

  dynamic copyWith({BlocStatus? status});
}
