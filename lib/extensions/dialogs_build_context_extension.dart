import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/models/action_sheet_action.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension DialogBuildContextExtension on BuildContext {
  Future<String?> askForAction({
    required String title,
    required List<ActionSheetAction> actions,
  }) async {
    return await read<DialogInterface>().askForAction(
      context: this,
      title: title,
      actions: actions,
    );
  }

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
    return await read<DialogInterface>().askForValue(
      context: this,
      title: title,
      message: message,
      placeholder: placeholder,
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      acceptLabel: acceptLabel,
      cancelLabel: cancelLabel,
    );
  }

  Future<bool> askForConfirmation({
    required String title,
    String? message,
  }) async {
    return await read<DialogInterface>().askForConfirmation(
      context: this,
      title: title,
      message: message,
    );
  }

  void showLoadingDialog() {
    read<DialogInterface>().showLoadingDialog(context: this);
  }

  void closeLoadingDialog() {
    read<DialogInterface>().closeLoadingDialog(context: this);
  }

  Future<void> showInfoDialog({
    required String title,
    required String info,
  }) async {
    read<DialogInterface>().showInfoDialog(
      context: this,
      title: title,
      info: info,
    );
  }

  void showSnackBar({required String message}) {
    read<DialogInterface>().showSnackBar(
      context: this,
      message: message,
    );
  }
}
