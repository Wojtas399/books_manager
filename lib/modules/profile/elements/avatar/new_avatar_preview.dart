import 'dart:ui';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:app/widgets/app_bars/dialog_app_bar.dart';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:app/widgets/buttons/medium_red_button.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';

class NewAvatarPreview extends StatelessWidget {
  late final String? _imgFile;
  late final String? _assetsPath;

  NewAvatarPreview({required AvatarInterface avatar}) {
    if (avatar is CustomAvatarInterface) {
      _imgFile = avatar.imgFilePathFromDevice;
      _assetsPath = null;
    } else if (avatar is StandardAvatarInterface) {
      _imgFile = null;
      _assetsPath = avatar.imgAssetsPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? imgFile = _imgFile;
    String? assetsPath = _assetsPath;

    return Scaffold(
      appBar: DialogAppBar(title: "Podgląd nowego avatar'u"),
      body: Container(
        width: double.infinity,
        color: HexColor(AppColors.LIGHT_BLUE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarCircleShape(
              isSelected: false,
              size: 250,
              child: imgFile != null
                  ? _CustomAvatar(imgFile: imgFile)
                  : assetsPath != null
                      ? _BasicAvatar(assetsPath: assetsPath)
                      : Text('No avatar...'),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumRedButton(
                  text: 'Anuluj',
                  icon: Icons.close,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 24),
                MediumGreenButton(
                  text: 'Zapisz',
                  icon: Icons.check,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CustomAvatar extends StatelessWidget {
  final String imgFile;

  const _CustomAvatar({required this.imgFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(File(imgFile)),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(imgFile)),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicAvatar extends StatelessWidget {
  final String assetsPath;

  _BasicAvatar({required this.assetsPath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetsPath, scale: 3);
  }
}
