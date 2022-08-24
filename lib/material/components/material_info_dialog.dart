import 'package:flutter/material.dart';

class MaterialInfoDialog extends StatelessWidget {
  final String title;
  final String? info;

  const MaterialInfoDialog({
    super.key,
    required this.title,
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    final String? info = this.info;

    return AlertDialog(
      title: Text(title),
      content: info != null ? Text(info) : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Zamknij'),
        ),
      ],
    );
  }
}
