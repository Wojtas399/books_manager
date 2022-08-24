import 'package:flutter/cupertino.dart';

class CupertinoInfoDialog extends StatelessWidget {
  final String title;
  final String? info;

  const CupertinoInfoDialog({
    super.key,
    required this.title,
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    final String? info = this.info;

    return CupertinoAlertDialog(
      title: Text(title),
      content: info != null
          ? Column(
              children: [
                const SizedBox(height: 8),
                Text(info),
              ],
            )
          : null,
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
