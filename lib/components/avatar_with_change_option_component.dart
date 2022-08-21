import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../config/animations/slide_up_route_animation.dart';
import '../interfaces/dialog_interface.dart';
import '../interfaces/factories/icon_factory_interface.dart';
import '../models/action_sheet_action.dart';
import '../models/avatar.dart';
import 'avatar_component.dart';
import 'basic_avatar_selection_component.dart';

class AvatarWithChangeOptionComponent extends StatefulWidget {
  final double? size;
  final Function(Avatar avatar)? onAvatarChanged;

  const AvatarWithChangeOptionComponent({
    super.key,
    this.size,
    this.onAvatarChanged,
  });

  @override
  State<AvatarWithChangeOptionComponent> createState() =>
      _AvatarWithChangeOptionComponentState();
}

class _AvatarWithChangeOptionComponentState
    extends State<AvatarWithChangeOptionComponent> {
  final ImagePicker _imagePicker = ImagePicker();
  Avatar? _chosenAvatar;

  @override
  Widget build(BuildContext context) {
    return AvatarComponent(
      avatar: _chosenAvatar ?? const BasicAvatar(type: BasicAvatarType.red),
      size: widget.size ?? 80,
      onPressed: () => _onAvatarPressed(),
    );
  }

  Future<void> _onAvatarPressed() async {
    final DialogInterface dialogInterface = context.read<DialogInterface>();
    final IconFactoryInterface iconFactoryInterface =
        context.read<IconFactoryInterface>();
    final int? selectedActionIndex = await dialogInterface.askForAction(
      context: context,
      title: 'Nowy avatar',
      actions: [
        ActionSheetAction(
          label: 'Domyślny',
          icon: iconFactoryInterface.createBookIcon(),
        ),
        ActionSheetAction(
          label: 'Z galerii',
          icon: iconFactoryInterface.createImageIcon(),
        ),
        ActionSheetAction(
          label: 'Z aparatu',
          icon: iconFactoryInterface.createCameraIcon(),
        ),
      ],
    );
    await _manageSelectedAction(selectedActionIndex);
  }

  Future<void> _manageSelectedAction(int? selectedActionIndex) async {
    if (selectedActionIndex == 0) {
      await _askForBasicAvatar();
    } else if (selectedActionIndex == 1) {
      await _askForImageFromGallery();
    } else if (selectedActionIndex == 2) {
      await _askForImageFromCamera();
    }
  }

  Future<void> _askForBasicAvatar() async {
    final BasicAvatarType? chosenAvatarType = await Navigator.of(context).push(
      SlideUpRouteAnimation(
        page: const BasicAvatarSelectionComponent(),
      ),
    );
    if (chosenAvatarType != null) {
      final Avatar newChosenAvatar = BasicAvatar(type: chosenAvatarType);
      setState(() {
        _chosenAvatar = newChosenAvatar;
      });
      _emitNewChosenAvatar(newChosenAvatar);
    }
  }

  Future<void> _askForImageFromGallery() async {
    final XFile? xFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (xFile != null) {
      final Avatar newChosenAvatar = FileAvatar(file: File(xFile.path));
      setState(() {
        _chosenAvatar = newChosenAvatar;
      });
      _emitNewChosenAvatar(newChosenAvatar);
    }
  }

  Future<void> _askForImageFromCamera() async {
    final XFile? xFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (xFile != null) {
      final Avatar newChosenAvatar = FileAvatar(file: File(xFile.path));
      setState(() {
        _chosenAvatar = newChosenAvatar;
      });
      _emitNewChosenAvatar(newChosenAvatar);
    }
  }

  void _emitNewChosenAvatar(Avatar avatar) {
    final Function(Avatar avatar)? onAvatarChanged = widget.onAvatarChanged;
    if (onAvatarChanged != null) {
      onAvatarChanged(avatar);
    }
  }
}
