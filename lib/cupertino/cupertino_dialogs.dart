import 'package:flutter/cupertino.dart';

import '../interfaces/dialog_interface.dart';
import '../models/action_sheet_action.dart';
import 'components/cupertino_info_dialog.dart';
import 'components/cupertino_custom_action_sheet.dart';
import 'components/cupertino_loading_dialog.dart';
import 'components/cupertino_snack_bar.dart';

class CupertinoDialogs implements DialogInterface {
  bool _isLoadingDialogOpened = false;

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

  @override
  void showLoadingDialog({required BuildContext context}) {
    if (!_isLoadingDialogOpened) {
      showCupertinoDialog(
        context: context,
        builder: (_) => const CupertinoLoadingDialog(),
      );
      _isLoadingDialogOpened = true;
    }
  }

  @override
  void closeLoadingDialog({required BuildContext context}) {
    if (_isLoadingDialogOpened) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoadingDialogOpened = false;
    }
  }

  @override
  void showInfoDialog({
    required BuildContext context,
    required String title,
    required String info,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoInfoDialog(
        title: title,
        info: info,
      ),
    );
  }

  @override
  void showSnackbar({
    required BuildContext context,
    required String message,
  }) {
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) => CupertinoSnackBar(message: message),
    );
    Future.delayed(
      const Duration(milliseconds: 4300),
      overlayEntry.remove,
    );
    Overlay.of(context)?.insert(overlayEntry);
  }
}
