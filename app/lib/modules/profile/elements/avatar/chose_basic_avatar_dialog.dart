import 'package:app/constants/theme.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/interfaces/avatars/avatar_interface.dart';
import 'package:app/widgets/app_bars/dialog_app_bar.dart';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChoseBasicAvatarDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DialogAppBar(title: 'Wybierz podstawowy avatar'),
      body: Container(
        color: HexColor(AppColors.LIGHT_BLUE),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Avatar(avatar: new StandardAvatarRed()),
            SizedBox(height: 32),
            _Avatar(avatar: new StandardAvatarGreen()),
            SizedBox(height: 32),
            _Avatar(avatar: new StandardAvatarBlue()),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final StandardAvatarInterface avatar;

  _Avatar({required this.avatar});

  @override
  Widget build(BuildContext context) {
    String? assetsPath = avatar.imgAssetsPath;

    if (assetsPath != null) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context, avatar);
        },
        child: AvatarCircleShape(
          isSelected: false,
          child: Image.asset(assetsPath, scale: 7),
          size: 100,
        ),
      );
    }
    return Text('No assets path...');
  }
}
