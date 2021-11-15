import 'package:flutter/material.dart';

class RawMaterialIconButton extends StatelessWidget {
  final IconData icon;
  final Function onClick;

  const RawMaterialIconButton({required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => onClick(),
      shape: CircleBorder(),
      constraints: BoxConstraints(minWidth: 36, minHeight: 36),
      padding: EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }
}