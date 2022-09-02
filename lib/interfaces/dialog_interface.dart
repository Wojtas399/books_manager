import 'package:flutter/widgets.dart';

import '../models/action_sheet_action.dart';

abstract class DialogInterface {
  Future<int?> askForAction({
    required String title,
    required List<ActionSheetAction> actions,
    BuildContext? context,
  });

  Future<String?> askForValue({
    required String title,
    String? message,
    String? placeholder,
    String initialValue = '',
    TextInputType? keyboardType,
    bool obscureText = false,
    String? acceptLabel,
    String? cancelLabel,
  });

  void showLoadingDialog({BuildContext? context});

  void closeLoadingDialog({BuildContext? context});

  Future<void> showInfoDialog({
    required String title,
    required String info,
    BuildContext? context,
  });

  void showSnackBar({
    required String message,
    BuildContext? context,
  });
}
