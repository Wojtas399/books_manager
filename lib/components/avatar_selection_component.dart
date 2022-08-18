import 'dart:io';
import 'package:flutter/widgets.dart';

import '../models/avatar.dart';
import 'avatar_component.dart';

class AvatarSelectionComponent extends StatefulWidget {
  final double? size;

  const AvatarSelectionComponent({
    super.key,
    this.size,
  });

  @override
  State<AvatarSelectionComponent> createState() =>
      _AvatarSelectionComponentState();
}

class _AvatarSelectionComponentState extends State<AvatarSelectionComponent> {
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
    );
  }
}
