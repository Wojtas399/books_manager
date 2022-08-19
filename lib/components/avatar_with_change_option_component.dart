import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/animations/slide_up_route_animation.dart';
import '../interfaces/dialog_interface.dart';
import '../interfaces/factories/icon_factory_interface.dart';
import '../models/action_sheet_action.dart';
import '../models/avatar.dart';
import 'avatar_component.dart';
import 'basic_avatar_selection_component.dart';

class AvatarWithChangeOptionComponent extends StatefulWidget {
  final double? size;

  const AvatarWithChangeOptionComponent({
    super.key,
    this.size,
  });

  @override
  State<AvatarWithChangeOptionComponent> createState() =>
      _AvatarWithChangeOptionComponentState();
}

class _AvatarWithChangeOptionComponentState
    extends State<AvatarWithChangeOptionComponent> {
  String? _chosenAvatarPath;

  @override
  Widget build(BuildContext context) {
    final String? chosenAvatarPath = _chosenAvatarPath;
    return AvatarComponent(
      avatar: chosenAvatarPath != null
          ? FileAvatar(
              file: File(chosenAvatarPath),
            )
          : BasicAvatar(type: BasicAvatarType.red),
      size: widget.size ?? 48,
      onPressed: () => _onAvatarPressed(),
    );
  }

  Future<void> _onAvatarPressed() async {
    final DialogInterface dialogInterface = context.read<DialogInterface>();
    final IconFactoryInterface iconFactoryInterface =
        context.read<IconFactoryInterface>();
    final int? selectedOption = await dialogInterface.askForAction(
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
    await _askForBasicAvatar();
  }

  Future<void> _askForBasicAvatar() async {
    final BasicAvatarType? selectedAvatarType =
        await Navigator.of(context).push(
      SlideUpRouteAnimation(
        page: const BasicAvatarSelectionComponent(),
      ),
    );
    print(selectedAvatarType);
  }
}
