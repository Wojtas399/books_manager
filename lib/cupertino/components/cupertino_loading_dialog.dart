import 'package:flutter/cupertino.dart';

class CupertinoLoadingDialog extends StatelessWidget {
  const CupertinoLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoAlertDialog(
      title: Text('Ładowanie...'),
      content: Column(
        children: [
          SizedBox(height: 8),
          CupertinoActivityIndicator(),
        ],
      ),
    );
  }
}
