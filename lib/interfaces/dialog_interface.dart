import 'package:flutter/widgets.dart';

import '../models/action_sheet_action.dart';

abstract class DialogInterface {
  Future<int?> askForAction({
    required BuildContext context,
    required String title,
    required List<ActionSheetAction> actions,
  });
}
