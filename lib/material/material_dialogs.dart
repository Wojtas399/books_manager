import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/material/components/material_confirmation_dialog.dart';
import 'package:app/material/components/material_custom_action_sheet.dart';
import 'package:app/material/components/material_info_dialog.dart';
import 'package:app/material/components/material_loading_dialog.dart';
import 'package:app/material/components/material_single_input_dialog.dart';
import 'package:app/models/action_sheet_action.dart';
import 'package:app/providers/navigator_key_provider.dart';
import 'package:flutter/material.dart';

class MaterialDialogs implements DialogInterface {
  bool _isLoadingDialogOpened = false;

  @override
  Future<int?> askForAction({
    required String title,
    required List<ActionSheetAction> actions,
    BuildContext? context,
  }) async {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      return await showModalBottomSheet(
        context: buildContext,
        builder: (_) => MaterialCustomActionSheet(
          title: title,
          actions: actions,
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
      return await showDialog(
        context: buildContext,
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
    return await showDialog(
          context: buildContext,
          builder: (_) => MaterialConfirmationDialog(
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
      showDialog(
        context: buildContext,
        barrierDismissible: false,
        builder: (_) => const MaterialLoadingDialog(),
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
      await showDialog(
        context: buildContext,
        builder: (_) => MaterialInfoDialog(
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
