import 'package:app/widgets/action_sheet/custom_action_sheet.dart';
import 'package:app/widgets/action_sheet/custom_action_sheet_item.dart';
import 'package:flutter/material.dart';

enum BookItemActions {
  updatePage,
  navigateToBookDetails,
}

class BookItemActionSheet extends StatelessWidget {
  final String bookTitle;

  BookItemActionSheet({required this.bookTitle});

  @override
  Widget build(BuildContext context) {
    return CustomActionSheet(
      title: bookTitle,
      items: [
        CustomActionSheetItem(
          text: 'Zaktualizuj stronę',
          icon: Icons.note_add,
          onTap: () => Navigator.pop(
            context,
            BookItemActions.updatePage,
          ),
        ),
        CustomActionSheetItem(
          text: 'Szczegóły książki',
          icon: Icons.feed,
          onTap: () => Navigator.pop(
            context,
            BookItemActions.navigateToBookDetails,
          ),
        ),
        CustomActionSheetItem(
          text: 'Zamknij',
          icon: Icons.close,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
