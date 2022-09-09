import 'dart:io';

import 'package:app/cupertino/cupertino_dialogs.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/material/material_dialogs.dart';

class DialogProvider {
  static DialogInterface provideDialogInterface() {
    if (Platform.isIOS) {
      return CupertinoDialogs();
    }
    return MaterialDialogs();
  }
}
