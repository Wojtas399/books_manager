import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ActionSheetAction extends Equatable {
  final String label;
  final Icon icon;

  const ActionSheetAction({
    required this.label,
    required this.icon,
  });

  @override
  List<Object> get props => [label, icon];
}
