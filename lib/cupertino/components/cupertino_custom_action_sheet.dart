import 'package:app/models/action_sheet_action.dart';
import 'package:flutter/cupertino.dart';

class CupertinoCustomActionSheet extends StatelessWidget {
  final String title;
  final List<ActionSheetAction> actions;

  const CupertinoCustomActionSheet({
    super.key,
    required this.title,
    required this.actions,
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
      actions: actions
          .map(
            (ActionSheetAction action) => _createCupertinoAction(
              action: action,
              context: context,
            ),
          )
          .toList(),
    );
  }

  Widget _createCupertinoAction({
    required ActionSheetAction action,
    required BuildContext context,
  }) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context, action.id);
      },
      child: Text(
        action.label,
        style: CupertinoTheme.of(context)
            .textTheme
            .actionTextStyle
            .copyWith(color: CupertinoColors.activeBlue),
      ),
    );
  }
}
