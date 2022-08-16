import 'package:app/widgets/action_sheet/custom_action_sheet.dart';
import 'package:app/widgets/action_sheet/custom_action_sheet_item.dart';
import 'package:flutter/material.dart';

class BookDetailsActionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomActionSheet(
      title: 'Edycja książki',
      items: [
        CustomActionSheetItem(
          text: 'Zmień zdjęcie',
          icon: Icons.image_outlined,
          onTap: () {
            Navigator.pop(context, BookDetailsEditAction.editImage);
          },
        ),
        CustomActionSheetItem(
          text: 'Zmień dane książki',
          icon: Icons.list_alt_rounded,
          onTap: () {
            Navigator.pop(context, BookDetailsEditAction.editDetails);
          },
        ),
        CustomActionSheetItem(
          text: 'Anuluj',
          icon: Icons.close,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

enum BookDetailsEditAction {
  editImage,
  editDetails,
}
