import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ActionSheetAction extends Equatable {
  final String label;
  final IconData iconData;

  const ActionSheetAction({
    required this.label,
    required this.iconData,
  });

  @override
  List<Object> get props => [label, iconData];
}
