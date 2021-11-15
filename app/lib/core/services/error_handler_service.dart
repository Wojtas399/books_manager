import 'package:app/core/keys.dart';
import 'package:app/widgets/dialogs/info_dialog.dart';
import 'package:flutter/material.dart';

class ErrorHandlerService {
  static displayFlutterError(String error) async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      await showDialog(
          context: context,
          builder: (context) {
            return InfoDialog(header: 'Error', message: error);
          });
    }
  }

  static displayError(String error) async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      Navigator.pop(context);
      await showDialog(
          context: context,
          builder: (context) {
            return _dialog(error);
          });
    }
  }

  static _dialog(String error) {
    if (error.contains(
      'The password is invalid or the user does not have a password.',
    )) {
      return InfoDialog(header: 'Błąd...', message: 'Niepoprawne hasło');
    } else if (error.contains(
        'There is no user record corresponding to this identifier.')) {
      return InfoDialog(
        header: 'Błąd: Błędne dane',
        message: 'Podano niepoprawny adres e-mail lub hasło',
      );
    } else {
      return InfoDialog(header: 'Error', message: error);
    }
  }
}
