import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/material/components/material_confirmation_dialog.dart';
import 'package:app/material/components/material_custom_action_sheet.dart';
import 'package:app/material/components/material_info_dialog.dart';
import 'package:app/material/components/material_loading_dialog.dart';
import 'package:app/material/components/material_single_input_dialog.dart';
import 'package:app/models/action_sheet_action.dart';
import 'package:flutter/material.dart';

class MaterialDialogs implements DialogInterface {
  bool _isLoadingDialogOpened = false;

  @override
  Future<String?> askForAction({
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
  }) async {
    return await showDialog(
      context: context,
      builder: (_) => MaterialSingleInputDialog(
        title: title,
        message: message,
        placeholder: placeholder,
        initialValue: initialValue,
        keyboardType: keyboardType,
        obscureText: obscureText,
        acceptLabel: acceptLabel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Future<bool> askForConfirmation({
    required BuildContext context,
    required String title,
    String? message,
  }) async {
    return await showDialog(
          context: context,
          builder: (_) => MaterialConfirmationDialog(
            title: title,
            message: message,
          ),
        ) ==
        true;
  }

  @override
  void showLoadingDialog({required BuildContext context}) {
    if (!_isLoadingDialogOpened) {
      showDialog(
        context: context,
        barrierDismissible: false,
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
  Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String info,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => MaterialInfoDialog(
        title: title,
        info: info,
      ),
    );
  }

  @override
  void showSnackBar({
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
