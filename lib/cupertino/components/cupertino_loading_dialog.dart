import 'package:flutter/cupertino.dart';

class CupertinoLoadingDialog extends StatelessWidget {
  const CupertinoLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Ładowanie...'),
      content: Column(
        children: const [
          SizedBox(height: 8),
          CupertinoActivityIndicator(),
        ],
      ),
    );
  }
}
