import 'package:app/constants/theme.dart';
import 'package:app/widgets/buttons/raw_material_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CalendarHeader extends StatelessWidget {
  final String header;
  final Function onChangeBack;
  final Function onChangeForward;

  const CalendarHeader({
    required this.header,
    required this.onChangeBack,
    required this.onChangeForward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        color: HexColor(AppColors.DARK_GREEN2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: RawMaterialIconButton(
                icon: Icons.arrow_back_ios_rounded,
                onClick: onChangeBack,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                header,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: RawMaterialIconButton(
                icon: Icons.arrow_forward_ios_rounded,
                onClick: onChangeForward,
              ),
            ),
          )
        ],
      ),
    );
  }
}
