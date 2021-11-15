import 'package:app/common/enum/avatar_type.dart';
import 'package:app/constants/theme.dart';
import 'package:app/core/services/avatar_book_service.dart';
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
            _Avatar(type: AvatarType.red),
            SizedBox(height: 32),
            _Avatar(type: AvatarType.green),
            SizedBox(height: 32),
            _Avatar(type: AvatarType.blue),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final AvatarBookService avatarBookService = AvatarBookService();
  final AvatarType type;

  _Avatar({required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, type);
      },
      child: AvatarBackground(
        isChosen: false,
        child: Image.asset(
          'assets/images/' + avatarBookService.getBookFileName(type),
          scale: 7,
        ),
        size: 100,
      ),
    );
  }
}
