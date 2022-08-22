import 'dart:io';

import '../cupertino/cupertino_dialogs.dart';
import '../interfaces/dialog_interface.dart';
import '../material/material_dialogs.dart';

class DialogProvider {
  static DialogInterface provideDialogInterface() {
    if (Platform.isIOS) {
      return CupertinoDialogs();
    }
    return MaterialDialogs();
  }
}