import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/interfaces/dialog_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BookPreviewActionsIcon extends StatelessWidget {
  const BookPreviewActionsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: PopupMenuButton(
        icon: const Icon(MdiIcons.dotsVertical),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              onTap: _onEditPressed,
              child: Row(
                children: const [
                  Icon(MdiIcons.pencil),
                  SizedBox(width: 8),
                  Text('Edytuj'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => _onDeletePressed(context),
              child: Row(
                children: const [
                  Icon(MdiIcons.delete),
                  SizedBox(width: 8),
                  Text('Usuń'),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  void _onEditPressed() {
    //TODO
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final bool confirmation = await _askForDeletionConfirmation(context);
    if (confirmation) {
      //TODO
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
