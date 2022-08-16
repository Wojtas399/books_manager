import 'package:app/widgets/action_sheet/custom_action_sheet.dart';
import 'package:app/widgets/action_sheet/custom_action_sheet_item.dart';
import 'package:flutter/material.dart';
import 'avatar_controller.dart';

class AvatarChoiceOptionsActionSheet extends StatelessWidget {
  const AvatarChoiceOptionsActionSheet();

  @override
  Widget build(BuildContext context) {
    return CustomActionSheet(
      title: 'Wybierz nowy avatar',
      items: [
        CustomActionSheetItem(
          text: 'Z galerii',
          icon: Icons.image_outlined,
          onTap: () {
            Navigator.pop(context, AvatarChoiceOptions.fromGallery);
          },
        ),
        CustomActionSheetItem(
          text: 'Podstawowy avatar',
          icon: Icons.book_outlined,
          onTap: () {
            Navigator.pop(context, AvatarChoiceOptions.basicAvatar);
          },
        ),
      ],
    );
  }
}
