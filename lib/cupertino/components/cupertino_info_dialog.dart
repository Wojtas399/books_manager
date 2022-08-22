import 'package:flutter/cupertino.dart';

class CupertinoInfoDialog extends StatelessWidget {
  final String title;
  final String info;

  const CupertinoInfoDialog({
    super.key,
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        children: [
          const SizedBox(height: 8),
          Text(info),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Zamknij'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
