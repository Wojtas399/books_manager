import 'package:app/config/navigation.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BookPreviewActionsIcon extends StatelessWidget {
  final editAction = 'Edit';
  final deleteAction = 'Delete';

  const BookPreviewActionsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final Color? iconColor = Theme.of(context).textTheme.bodyText1?.color;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: PopupMenuButton(
        icon: const Icon(MdiIcons.dotsVertical),
        onSelected: (String action) => _manageAction(action, context),
        itemBuilder: (BuildContext context) {
          return <PopupMenuItem<String>>[
            PopupMenuItem(
              value: editAction,
              child: Row(
                children: [
                  Icon(MdiIcons.pencil, color: iconColor),
                  const SizedBox(width: 8),
                  const Text('Edytuj'),
                ],
              ),
            ),
            PopupMenuItem(
              value: deleteAction,
              child: Row(
                children: [
                  Icon(MdiIcons.delete, color: iconColor),
                  const SizedBox(width: 8),
                  const Text('Usuń'),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  void _manageAction(String action, BuildContext context) {
    if (action == editAction) {
      _onEditPressed(context);
    } else if (action == deleteAction) {
      _onDeletePressed(context);
    }
  }

  void _onEditPressed(BuildContext context) {
    final String bookId = context.read<BookPreviewBloc>().state.bookId;
    Navigation.navigateToBookEditor(bookId: bookId);
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final BookPreviewBloc bookPreviewBloc = context.read<BookPreviewBloc>();
    final bool confirmation = await _askForDeletionConfirmation(context);
    if (confirmation) {
      bookPreviewBloc.add(
        const BookPreviewEventDeleteBook(),
      );
    }
  }

  Future<bool> _askForDeletionConfirmation(BuildContext context) async {
    final String? title = context.read<BookPreviewBloc>().state.title;
    return await context.read<DialogInterface>().askForConfirmation(
          title: 'Usuwanie książki',
          message: 'Czy na pewno chcesz usunąć książkę "$title"?',
        );
  }
}
