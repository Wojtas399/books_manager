import 'package:app/config/themes/gradients.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddBookAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddBookAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HexColor(AppColors.LIGHT_GREEN),
      title: Text(
        'Dodaj książkę',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      bottom: TabBar(
        labelColor: Colors.black,
        indicatorColor: HexColor(AppColors.DARK_GREEN),
        tabs: [
          Tab(text: 'Szczegóły'),
          Tab(text: 'Zdjęcie'),
          Tab(text: 'Podsumowanie'),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Gradients.greenBlueGradient(),
        ),
      ),
    );
  }
}