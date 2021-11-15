import 'package:app/widgets/icons/default_icon.dart';
import 'package:flutter/material.dart';

class CustomActionSheetItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const CustomActionSheetItem({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(text, style: Theme.of(context).textTheme.button),
          leading: DefaultIcon(
            icon: icon,
          ),
          onTap: () {
            onTap();
          },
        ),
        Divider(),
      ],
    );
  }
}
