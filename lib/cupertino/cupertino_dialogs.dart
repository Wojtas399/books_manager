import 'package:flutter/cupertino.dart';

import '../interfaces/dialog_interface.dart';
import '../models/action_sheet_action.dart';
import '../providers/navigator_key_provider.dart';
import '../ui/errors_messages.dart';
import 'components/cupertino_info_dialog.dart';
import 'components/cupertino_custom_action_sheet.dart';
import 'components/cupertino_loading_dialog.dart';
import 'components/cupertino_single_input_dialog.dart';
import 'components/cupertino_snack_bar.dart';

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
    bool obscureText = false,
  }) async {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext != null) {
      return await showCupertinoDialog(
        context: buildContext,
        builder: (_) => CupertinoSingleInputDialog(
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
      showCupertinoDialog(
        context: buildContext,
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
  void showInfoDialog({
    required String title,
    required String info,
    BuildContext? context,
  }) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      showCupertinoDialog(
        context: buildContext,
        builder: (_) => CupertinoInfoDialog(
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
      final overlayEntry = OverlayEntry(
        builder: (BuildContext context) => CupertinoSnackBar(message: message),
      );
      Future.delayed(
        const Duration(milliseconds: 4300),
        overlayEntry.remove,
      );
      Overlay.of(buildContext)?.insert(overlayEntry);
    }
  }

  @override
  void showLossOfConnectionDialog({BuildContext? context}) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      showInfoDialog(title: ErrorsMessages.lossOfConnection, info: '');
    }
  }

  @override
  void showTimeoutDialog({BuildContext? context}) {
    final BuildContext? buildContext = context ?? _getNavigatorContext();
    if (buildContext != null) {
      showInfoDialog(
        title: 'Przekroczony czas wykonania operacji',
        info: ErrorsMessages.timeoutMessage,
      );
    }
  }

  BuildContext? _getNavigatorContext() {
    return NavigatorKeyProvider.getContext();
  }
}
