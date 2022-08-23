import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class BottomNavBar extends Equatable {
  final List<BottomNavigationBarItem> items;
  final int selectedItemIndex;
  final Function(int pressedItemIndex)? onItemPressed;

  const BottomNavBar({
    required this.items,
    required this.selectedItemIndex,
    this.onItemPressed,
  });

  @override
  List<Object> get props => [
        items,
        selectedItemIndex,
        onItemPressed ?? '',
      ];
}
