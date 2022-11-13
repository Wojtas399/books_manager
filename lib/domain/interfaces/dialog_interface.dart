import 'package:app/models/action_sheet_action.dart';
import 'package:flutter/widgets.dart';

abstract class DialogInterface {
  Future<String?> askForAction({
    required BuildContext context,
    required String title,
    required List<ActionSheetAction> actions,
  });

  Future<String?> askForValue({
    required BuildContext context,
    required String title,
    String? message,
    String? placeholder,
    String initialValue = '',
    TextInputType? keyboardType,
    bool obscureText = false,
    String? acceptLabel,
    String? cancelLabel,
  });

  Future<bool> askForConfirmation({
    required BuildContext context,
    required String title,
    String? message,
  });

  void showLoadingDialog({required BuildContext context});

  void closeLoadingDialog({required BuildContext context});

  Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String info,
  });

  void showSnackBar({
    required BuildContext context,
    required String message,
  });
}
