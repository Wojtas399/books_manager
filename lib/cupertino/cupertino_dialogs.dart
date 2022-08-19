import 'package:flutter/cupertino.dart';

import '../interfaces/dialog_interface.dart';
import '../models/action_sheet_action.dart';
import 'components/cupertino_custom_action_sheet.dart';

class CupertinoDialogs implements DialogInterface {
  @override
  Future<int?> askForAction({
    required BuildContext context,
    required String title,
    required List<ActionSheetAction> actions,
  }) async {
    return await showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoCustomActionSheet(
        title: title,
        actionsLabels: actions
            .map(
              (ActionSheetAction action) => action.label,
            )
            .toList(),
      ),
    );
  }
}
