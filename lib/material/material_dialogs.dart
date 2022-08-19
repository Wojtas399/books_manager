import 'package:flutter/material.dart';

import '../interfaces/dialog_interface.dart';
import '../models/action_sheet_action.dart';
import 'components/material_custom_action_sheet.dart';

class MaterialDialogs implements DialogInterface {
  @override
  Future<int?> askForAction({
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
}
