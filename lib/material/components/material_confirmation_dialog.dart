import 'package:flutter/material.dart';

class MaterialConfirmationDialog extends StatelessWidget {
  final String title;
  final String? message;

  const MaterialConfirmationDialog({
    super.key,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message ?? ''),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _onCancelPressed(context),
          child: const Text('Anuluj'),
        ),
        TextButton(
          onPressed: () => _onAcceptPressed(context),
          child: const Text('Zatwierdź'),
        ),
      ],
    );
  }

  void _onCancelPressed(BuildContext context) {
    Navigator.pop(context, false);
  }

  void _onAcceptPressed(BuildContext context) {
    Navigator.pop(context, true);
  }
}
