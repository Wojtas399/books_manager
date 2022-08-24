import 'package:flutter/cupertino.dart';

class CupertinoCustomActionSheet extends StatelessWidget {
  final String title;
  final List<String> actionsLabels;

  const CupertinoCustomActionSheet({
    super.key,
    required this.title,
    required this.actionsLabels,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(title),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Anuluj',
          style: CupertinoTheme.of(context)
              .textTheme
              .actionTextStyle
              .copyWith(color: CupertinoColors.destructiveRed),
        ),
      ),
      actions: actionsLabels
          .asMap()
          .entries
          .map(
            (MapEntry<int, String> entry) => _createCupertinoAction(
              label: entry.value,
              index: entry.key,
              context: context,
            ),
          )
          .toList(),
    );
  }

  Widget _createCupertinoAction({
    required String label,
    required int index,
    required BuildContext context,
  }) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context, index);
      },
      child: Text(
        label,
        style: CupertinoTheme.of(context).textTheme.actionTextStyle,
      ),
    );
  }
}
