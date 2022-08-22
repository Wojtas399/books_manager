import 'package:flutter/material.dart';

import '../interfaces/dialog_interface.dart';
import '../models/action_sheet_action.dart';
import 'components/material_custom_action_sheet.dart';
import 'components/material_loading_dialog.dart';
import 'components/material_info_dialog.dart';

class MaterialDialogs implements DialogInterface {
  bool _isLoadingDialogOpened = false;

  @override
  Future<int?> askForAction({
    required BuildContext context,
    required String title,
    required List<ActionSheetAction> actions,
  }) async {
    return await showModalBottomSheet(
      context: context,
      builder: (_) => MaterialCustomActionSheet(
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  void showLoadingDialog({required BuildContext context}) {
    if (!_isLoadingDialogOpened) {
      showDialog(
        context: context,
        builder: (_) => const MaterialLoadingDialog(),
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
    showDialog(
      context: context,
      builder: (_) => MaterialInfoDialog(
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
