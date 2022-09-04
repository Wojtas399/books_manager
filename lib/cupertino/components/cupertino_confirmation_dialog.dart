import 'package:flutter/cupertino.dart';

class CupertinoConfirmationDialog extends StatelessWidget {
  final String title;
  final String? message;

  const CupertinoConfirmationDialog({
    super.key,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message ?? ''),
      actions: [
        CupertinoDialogAction(
          onPressed: () => _onCancelPressed(context),
          child: const Text(
            'Anuluj',
            style: TextStyle(color: CupertinoColors.destructiveRed),
          ),
        ),
        CupertinoDialogAction(
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
