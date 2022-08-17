import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomActionSheet extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const CustomActionSheet({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor(AppColors.LIGHT_BLUE),
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        children: [
          _Title(title: title),
          SizedBox(height: 40),
          ...items,
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
