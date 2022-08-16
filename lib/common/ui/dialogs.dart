import 'package:app/core/keys.dart';
import 'package:app/widgets/dialogs/confirmation_dialog.dart';
import 'package:app/widgets/dialogs/info_dialog.dart';
import 'package:app/widgets/dialogs/single_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/dialogs/loading_dialog.dart';

class Dialogs {
  static showLoadingDialog() async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return LoadingDialog();
        },
      );
    }
  }

  static Future<String?> showSingleInputDialog({
    required String title,
    required TextEditingController controller,
    String? label,
    TextInputType? type,
    String? Function(String?)? validator,
  }) async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      return await showDialog(
        context: context,
        builder: (context) {
          return SingleInputDialog(
            title: title,
            label: label,
            type: type,
            controller: controller,
            validator: validator,
          );
        },
      );
    }
  }

  static showInfoDialog({
    required String header,
    required String message,
  }) async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return InfoDialog(header: header, message: message);
        },
      );
    }
  }

  static Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
  }) async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      return await showDialog(
        context: context,
        builder: (_) {
          return ConfirmationDialog(title: title, message: message);
        },
      );
    }
  }

  static Future<dynamic> showCustomDialog({
    required Widget child,
  }) async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      return await showDialog(context: context, builder: (_) => child);
    }
  }
}
