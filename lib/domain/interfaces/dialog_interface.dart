import 'package:app/models/action_sheet_action.dart';
import 'package:flutter/widgets.dart';

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

  Future<bool> askForConfirmation({
    required String title,
    String? message,
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