import 'package:flutter/material.dart';

class MaterialInfoDialog extends StatelessWidget {
  final String title;
  final String info;

  const MaterialInfoDialog({
    super.key,
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(info),
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
