import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/models/action_sheet_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BookImagePickerComponent extends StatelessWidget {
  final Uint8List? imageData;
  final Uint8List? originalImageData;
  final bool canDisplayRestoreImageAction;
  final Function(Uint8List? imageData)? onImageDataChanged;

  const BookImagePickerComponent({
    super.key,
    required this.imageData,
    this.originalImageData,
    this.canDisplayRestoreImageAction = false,
    this.onImageDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onPressed(context),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.36,
        width: MediaQuery.of(context).size.width * 0.65,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: _Image(imageData: imageData),
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final _ImageAction? action = await _askForAction(context);
    if (action != null) {
      await _manageSelectedAction(action);
    }
  }

  Future<_ImageAction?> _askForAction(BuildContext context) async {
    final List<ActionSheetAction> actions = _createActionsToSelect();
    final String? actionId = await context.read<DialogInterface>().askForAction(
          title: imageData != null ? 'Edytuj zdjęcie' : 'Dodaj zdjęcie',
          actions: actions,
        );
    return actionId.toImageAction();
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
      case _ImageAction.restoreOriginal:
        _restoreOriginal();
        break;
    }
  }

  List<ActionSheetAction> _createActionsToSelect() {
    final List<ActionSheetAction> actions = [
      ActionSheetAction(
        id: _ImageAction.fromGallery.name,
        label: 'Z galerii',
        iconData: MdiIcons.image,
      ),
      ActionSheetAction(
        id: _ImageAction.fromCamera.name,
        label: 'Z aparatu',
        iconData: MdiIcons.camera,
      ),
    ];
    if (imageData != null) {
      actions.add(
        ActionSheetAction(
          id: _ImageAction.delete.name,
          label: 'Usuń',
          iconData: MdiIcons.delete,
        ),
      );
    }
    if (canDisplayRestoreImageAction && imageData != originalImageData) {
      actions.add(
        ActionSheetAction(
          id: _ImageAction.restoreOriginal.name,
          label: 'Przywróć początkowe zdjęcie',
          iconData: MdiIcons.restore,
        ),
      );
    }
    return actions;
  }

  Future<void> _setImageFromGallery() async {
    final Uint8List? imageData = await _getImageFromGallery();
    if (imageData != null) {
      _emitNewImage(imageData);
    }
  }

  Future<void> _setImageFromCamera() async {
    final Uint8List? imageData = await _getImageFromCamera();
    if (imageData != null) {
      _emitNewImage(imageData);
    }
  }

  void _deleteImage() {
    _emitNewImage(null);
  }

  void _restoreOriginal() {
    _emitNewImage(originalImageData);
  }

  Future<Uint8List?> _getImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? xFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return await xFile?.readAsBytes();
  }

  Future<Uint8List?> _getImageFromCamera() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? xFile = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    return await xFile?.readAsBytes();
  }

  void _emitNewImage(Uint8List? newImageData) {
    final Function(Uint8List? imageData)? onImageDataChanged =
        this.onImageDataChanged;
    if (onImageDataChanged != null) {
      onImageDataChanged(newImageData);
    }
  }
}

class _Image extends StatelessWidget {
  final Uint8List? imageData;

  const _Image({this.imageData});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = this.imageData;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BookImageComponent(
        image: imageData != null
            ? Image.memory(
                imageData,
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
  restoreOriginal,
}

extension _StringExtensions on String? {
  _ImageAction? toImageAction() {
    switch (this) {
      case 'fromGallery':
        return _ImageAction.fromGallery;
      case 'fromCamera':
        return _ImageAction.fromCamera;
      case 'delete':
        return _ImageAction.delete;
      case 'restoreOriginal':
        return _ImageAction.restoreOriginal;
      default:
        return null;
    }
  }
}
