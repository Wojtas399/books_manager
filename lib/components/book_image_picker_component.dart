import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/models/action_sheet_action.dart';
import 'package:app/models/image.dart' as image_entity;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BookImagePickerComponent extends StatelessWidget {
  final image_entity.Image? image;
  final image_entity.Image? originalImage;
  final bool canDisplayRestoreImageAction;
  final Function(image_entity.Image? image)? onImageChanged;

  const BookImagePickerComponent({
    super.key,
    required this.image,
    this.originalImage,
    this.canDisplayRestoreImageAction = false,
    this.onImageChanged,
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
          child: _Image(imageData: image?.data),
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
          title: image != null ? 'Edytuj zdjęcie' : 'Dodaj zdjęcie',
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
    if (image != null) {
      actions.add(
        ActionSheetAction(
          id: _ImageAction.delete.name,
          label: 'Usuń',
          iconData: MdiIcons.delete,
        ),
      );
    }
    if (canDisplayRestoreImageAction && image != originalImage) {
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
    final image_entity.Image? newImage = await _getImageFromGallery();
    if (newImage != null) {
      _emitNewImage(newImage);
    }
  }

  Future<void> _setImageFromCamera() async {
    final image_entity.Image? newImage = await _getImageFromCamera();
    if (newImage != null) {
      _emitNewImage(newImage);
    }
  }

  void _deleteImage() {
    _emitNewImage(null);
  }

  void _restoreOriginal() {
    _emitNewImage(originalImage);
  }

  Future<image_entity.Image?> _getImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? xFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return await _mapXFileToImageFile(xFile);
  }

  Future<image_entity.Image?> _getImageFromCamera() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? xFile = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    return await _mapXFileToImageFile(xFile);
  }

  void _emitNewImage(image_entity.Image? newImage) {
    final Function(image_entity.Image? image)? onImageChanged =
        this.onImageChanged;
    if (onImageChanged != null) {
      onImageChanged(newImage);
    }
  }

  Future<image_entity.Image?> _mapXFileToImageFile(XFile? xFile) async {
    final Uint8List? imageData = await xFile?.readAsBytes();
    if (imageData == null || xFile == null) {
      return null;
    }
    return image_entity.Image(fileName: xFile.name, data: imageData);
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
