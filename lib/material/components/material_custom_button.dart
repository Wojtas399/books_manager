import 'package:flutter/material.dart';

class MaterialCustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const MaterialCustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
