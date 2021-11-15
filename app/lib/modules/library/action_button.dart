import 'package:app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hexcolor/hexcolor.dart';

class LibraryScreenActionButton extends StatelessWidget {
  final Function onTapFilter;
  final Function onTapAddBook;

  const LibraryScreenActionButton({
    required this.onTapFilter,
    required this.onTapAddBook,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: HexColor(AppColors.DARK_GREEN),
      foregroundColor: Colors.white,
      activeBackgroundColor: HexColor(AppColors.RED),
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: HexColor(AppColors.DARK_GREEN),
          label: 'Dodaj',
          onTap: () {
            onTapAddBook();
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.filter_list_rounded, color: Colors.white),
          backgroundColor: HexColor(AppColors.DARK_GREEN),
          label: 'Filtruj',
          onTap: () {
            onTapFilter();
          },
        ),
      ],
    );
  }
}
