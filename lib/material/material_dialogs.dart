import 'package:flutter/material.dart';

import '../interfaces/dialog_interface.dart';
import '../models/action_sheet_action.dart';
import '../providers/navigator_key_provider.dart';
import 'components/material_custom_action_sheet.dart';
import 'components/material_loading_dialog.dart';
import 'components/material_info_dialog.dart';
import 'components/material_single_input_dialog.dart';

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
    bool obscureText = false,
  }) async {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext != null) {
      return await showDialog(
        context: buildContext,
        builder: (_) => MaterialSingleInputDialog(
          title: title,
          message: message,
          placeholder: placeholder,
          obscureText: obscureText,
        ),
      );
    }
    return null;
  }

  @override
  void showLoadingDialog({BuildContext? context}) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (!_isLoadingDialogOpened && buildContext != null) {
      showDialog(
        context: buildContext,
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
  void showInfoDialog({
    required String title,
    required String info,
    BuildContext? context,
  }) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      showDialog(
        context: buildContext,
        builder: (_) => MaterialInfoDialog(
          title: title,
          info: info,
        ),
      );
    }
  }

  @override
  void showSnackbar({
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
