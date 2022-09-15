import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ActionSheetAction extends Equatable {
  final String id;
  final String label;
  final IconData iconData;

  const ActionSheetAction({
    required this.id,
    required this.label,
    required this.iconData,
  });

  @override
  List<Object> get props => [id, label, iconData];
}
