import 'dart:io';

import 'package:app/components/book_image_component.dart';
import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:app/interfaces/dialog_interface.dart';
import 'package:app/models/action_sheet_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BookCreatorImage extends StatefulWidget {
  const BookCreatorImage({super.key});

  @override
  State<BookCreatorImage> createState() => _BookCreatorImageState();
}

class _BookCreatorImageState extends State<BookCreatorImage> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final String? imagePath = context.select(
      (BookCreatorBloc bloc) => bloc.state.imagePath,
    );

    return GestureDetector(
      onTap: () => _onPressed(imagePath),
      child: Container(
        height: 300,
        width: 260,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 7,
              spreadRadius: 5,
            ),
          ],
        ),
        child: _Image(imagePath: imagePath),
      ),
    );
  }

  Future<void> _onPressed(String? imagePath) async {
    final _ImageAction? action = await _askForAction(imagePath);
    if (action != null) {
      await _manageSelectedAction(action);
    }
  }

  Future<_ImageAction?> _askForAction(String? imagePath) async {
    final List<ActionSheetAction> actions = _createActionsToSelect(imagePath);
    final int? actionIndex = await context.read<DialogInterface>().askForAction(
          title: imagePath != null ? 'Edytuj zdjęcie' : 'Dodaj zdjęcie',
          actions: actions,
        );
    if (actionIndex != null) {
      return _ImageAction.values[actionIndex];
    }
    return null;
  }

  Future<void> _manageSelectedAction(_ImageAction action) async {
    switch (action) {
      case _ImageAction.fromGallery:
        await _setImageFromGallery();
        break;
      case _ImageAction.fromCamera:
        await _setImageFromCamera();
        break;
      case _ImageAction.delete:
        _deleteImage();
        break;
    }
  }

  List<ActionSheetAction> _createActionsToSelect(String? imagePath) {
    final List<ActionSheetAction> actions = [
      const ActionSheetAction(
        label: 'Z galerii',
        iconData: MdiIcons.image,
      ),
      const ActionSheetAction(
        label: 'Z aparatu',
        iconData: MdiIcons.camera,
      ),
    ];
    if (imagePath != null) {
      actions.add(
        const ActionSheetAction(
          label: 'Usuń',
          iconData: MdiIcons.delete,
        ),
      );
    }
    return actions;
  }

  Future<void> _setImageFromGallery() async {
    final String? imagePath = await _getImageFromGallery();
    if (imagePath != null && mounted) {
      context.read<BookCreatorBloc>().add(
            BookCreatorEventChangeImagePath(imagePath: imagePath),
          );
    }
  }

  Future<void> _setImageFromCamera() async {
    final String? imagePath = await _getImageFromCamera();
    if (imagePath != null && mounted) {
      context.read<BookCreatorBloc>().add(
            BookCreatorEventChangeImagePath(imagePath: imagePath),
          );
    }
  }

  void _deleteImage() {
    context.read<BookCreatorBloc>().add(
          const BookCreatorEventRemoveImage(),
        );
  }

  Future<String?> _getImageFromGallery() async {
    final XFile? xFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return xFile?.path;
  }

  Future<String?> _getImageFromCamera() async {
    final XFile? xFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    return xFile?.path;
  }
}

class _Image extends StatelessWidget {
  final String? imagePath;

  const _Image({this.imagePath});

  @override
  Widget build(BuildContext context) {
    final String? imagePath = this.imagePath;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BookImageComponent(
        image: imagePath != null
            ? Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              )
            : null,
        bookIconSize: 120,
      ),
    );
  }
}

enum _ImageAction {
  fromGallery,
  fromCamera,
  delete,
}
