import 'package:app/config/themes/gradients.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class DialogAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  DialogAppBar({required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: _Title(title: title),
      backgroundColor: HexColor(AppColors.LIGHT_GREEN),
      iconTheme: IconThemeData(
        color: HexColor('#000000'),
      ),
      actions: [
        _CloseButton(),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Gradients.greenBlueGradient(),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: HexColor('#000000'),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.0),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.pop(context);
        },
        shape: CircleBorder(),
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.all(0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
    );
  }
}