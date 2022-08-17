import 'package:app/config/themes/gradients.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BookDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function onClickDeleteButton;

  const BookDetailsAppBar({required this.onClickDeleteButton});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HexColor(AppColors.LIGHT_GREEN),
      title: Text(
        'Szczegóły książki',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Gradients.greenBlueGradient(),
        ),
      ),
      actions: [
        _DeleteButton(onClick: () {
          onClickDeleteButton();
        }),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final Function onClick;

  const _DeleteButton({required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.0),
      child: RawMaterialButton(
        onPressed: () {
          onClick();
        },
        shape: CircleBorder(),
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.all(0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Icon(
          Icons.delete,
          color: Colors.black,
        ),
      ),
    );
  }
}
