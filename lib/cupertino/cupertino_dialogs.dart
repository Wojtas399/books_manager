import 'package:app/cupertino/components/cupertino_confirmation_dialog.dart';
import 'package:app/cupertino/components/cupertino_custom_action_sheet.dart';
import 'package:app/cupertino/components/cupertino_info_dialog.dart';
import 'package:app/cupertino/components/cupertino_loading_dialog.dart';
import 'package:app/cupertino/components/cupertino_single_input_dialog.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/models/action_sheet_action.dart';
import 'package:app/providers/navigator_key_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoDialogs implements DialogInterface {
  bool _isLoadingDialogOpened = false;

  @override
  Future<int?> askForAction({
    required String title,
    required List<ActionSheetAction> actions,
    BuildContext? context,
  }) async {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      return await showCupertinoModalPopup(
        context: buildContext,
        builder: (_) => CupertinoCustomActionSheet(
          title: title,
          actionsLabels:
              actions.map((ActionSheetAction action) => action.label).toList(),
        ),
      );
    }
    return null;
  }

  @override
  Future<String?> askForValue({
    required String title,
    String? message,
    String? placeholder,
    String initialValue = '',
    TextInputType? keyboardType,
    bool obscureText = false,
    String? acceptLabel,
    String? cancelLabel,
  }) async {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext != null) {
      return await showCupertinoDialog(
        context: buildContext,
        builder: (_) => CupertinoSingleInputDialog(
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
    return null;
  }

  @override
  Future<bool> askForConfirmation({
    required String title,
    String? message,
  }) async {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext == null) {
      return false;
    }
    return await showCupertinoDialog(
          context: buildContext,
          builder: (_) => CupertinoConfirmationDialog(
            title: title,
            message: message,
          ),
        ) ==
        true;
  }

  @override
  void showLoadingDialog({BuildContext? context}) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (!_isLoadingDialogOpened && buildContext != null) {
      showCupertinoDialog(
        context: buildContext,
        barrierDismissible: false,
        builder: (_) => const CupertinoLoadingDialog(),
      );
      _isLoadingDialogOpened = true;
    }
  }

  @override
  void closeLoadingDialog({BuildContext? context}) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (_isLoadingDialogOpened && buildContext != null) {
      Navigator.of(buildContext, rootNavigator: true).pop();
      _isLoadingDialogOpened = false;
    }
  }

  @override
  Future<void> showInfoDialog({
    required String title,
    required String info,
    BuildContext? context,
  }) async {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      await showCupertinoDialog(
        context: buildContext,
        builder: (_) => CupertinoInfoDialog(
          title: title,
          info: info,
        ),
      );
    }
  }

  @override
  void showSnackBar({
    required String message,
    BuildContext? context,
  }) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      ScaffoldMessenger.of(buildContext).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  BuildContext? _getNavigatorContext() {
    return NavigatorKeyProvider.getContext();
  }
}
