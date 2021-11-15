import 'dart:ui';
import 'package:app/common/enum/avatar_type.dart';
import 'package:app/constants/theme.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/widgets/app_bars/dialog_app_bar.dart';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:app/widgets/buttons/medium_red_button.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';

class NewAvatarPreview extends StatelessWidget {
  final AvatarInfo avatarInfo;

  NewAvatarPreview({required this.avatarInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DialogAppBar(title: "Podgląd nowego avatar'u"),
      body: Container(
        width: double.infinity,
        color: HexColor(AppColors.LIGHT_BLUE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarBackground(
              isChosen: false,
              size: 250,
              child: avatarInfo.avatarType == AvatarType.custom
                  ? _CustomAvatar(imgFile: avatarInfo.avatarUrl)
                  : _BasicAvatar(avatarType: avatarInfo.avatarType),
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
    if (imgFile == '') {
      return Text('');
    }
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
  final AvatarBookService avatarBookService = AvatarBookService();
  final AvatarType? avatarType;

  _BasicAvatar({required this.avatarType});

  @override
  Widget build(BuildContext context) {
    AvatarType? type = avatarType;
    if (type == null) {
      return Text('');
    }
    return Image.asset(
      'assets/images/' + avatarBookService.getBookFileName(type),
      scale: 3,
    );
  }
}
