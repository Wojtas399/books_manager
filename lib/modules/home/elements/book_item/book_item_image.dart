import 'package:app/config/themes/app_colors.dart';
import 'package:app/widgets/icons/large_icon.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BookItemImage extends StatelessWidget {
  final String? imgUrl;

  const BookItemImage({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    String? url = imgUrl;
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9),
          bottomLeft: Radius.circular(9),
        ),
        color: HexColor(AppColors.LIGHT_GREEN2),
      ),
      child: url != null
          ? ClipRRect(
              child: Image(image: NetworkImage(url), fit: BoxFit.contain),
            )
          : LargeIcon(
              icon: Icons.image,
              color: AppColors.LIGHT_GREEN,
            ),
    );
  }
}
