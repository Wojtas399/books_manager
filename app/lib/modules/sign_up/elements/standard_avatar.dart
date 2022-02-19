import 'package:app/models/avatar_model.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:app/interfaces/avatars/avatar_interface.dart';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:flutter/material.dart';

class StandardAvatar extends StatelessWidget {
  final AvatarType avatarType;
  final bool isSelected;
  final VoidCallback onSelect;

  StandardAvatar({
    required this.avatarType,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    StandardAvatarInterface? avatar = _getAvatar(avatarType);
    String? assetsPath = avatar?.imgAssetsPath;

    if (assetsPath != null) {
      return GestureDetector(
        onTap: () => onSelect(),
        child: AvatarCircleShape(
          isSelected: isSelected,
          child: Image.asset(
            assetsPath,
            scale: 13.5,
          ),
          size: 60,
        ),
      );
    }
    return Text('no avatar');
  }

  StandardAvatarInterface? _getAvatar(AvatarType type) {
    if (type == AvatarType.red) {
      return new StandardAvatarRed();
    } else if (type == AvatarType.blue) {
      return new StandardAvatarBlue();
    } else if (type == AvatarType.green) {
      return new StandardAvatarGreen();
    }
  }
}
