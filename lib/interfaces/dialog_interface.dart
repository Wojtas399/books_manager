import 'package:flutter/widgets.dart';

import '../models/action_sheet_action.dart';

abstract class DialogInterface {
  Future<int?> askForAction({
    required BuildContext context,
    required String title,
    required List<ActionSheetAction> actions,
  });

  void showLoadingDialog({required BuildContext context});

  void closeLoadingDialog({required BuildContext context});

  void showInfoDialog({
    required BuildContext context,
    required String title,
    required String info,
  });

  void showSnackbar({
    required BuildContext context,
    required String message,
  });
}
