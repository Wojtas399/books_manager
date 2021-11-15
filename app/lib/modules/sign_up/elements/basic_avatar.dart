import 'package:app/common/enum/avatar_type.dart';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:flutter/material.dart';

class BasicAvatar extends StatelessWidget {
  final AvatarType type;
  final bool isChosen;
  final VoidCallback onClick;

  BasicAvatar({
    required this.type,
    required this.isChosen,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: AvatarBackground(
        isChosen: isChosen,
        child: _avatarImage(),
        size: 60,
      ),
    );
  }

  Widget _avatarImage() {
    String path = 'assets/images/';
    String bookType = '';
    switch (type) {
      case AvatarType.red:
        {
          bookType = 'RedBook.png';
        }
        break;
      case AvatarType.green:
        {
          bookType = 'GreenBook.png';
        }
        break;
      case AvatarType.blue:
        {
          bookType = 'BlueBook.png';
        }
        break;
      case AvatarType.custom:
        {}
        break;
    }
    return Image.asset(
      path + bookType,
      scale: 13.5,
    );
  }
}
