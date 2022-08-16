import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultIcon extends StatelessWidget {
  final IconData icon;

  DefaultIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.black87,
      size: 24,
    );
  }
}