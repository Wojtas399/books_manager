import 'package:app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FilterOptionItem extends StatelessWidget {
  final String sectionName;
  final String filterName;
  final Function onClickDelete;

  const FilterOptionItem({
    required this.sectionName,
    required this.filterName,
    required this.onClickDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        color: HexColor(AppColors.DARK_GREEN),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              _Description(sectionName: sectionName, filterName: filterName),
              SizedBox(width: 8.0),
              _DeleteIcon(
                onPressed: () {
                  onClickDelete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String sectionName;
  final String filterName;

  const _Description({required this.sectionName, required this.filterName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionName,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Text(
          filterName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _DeleteIcon extends StatelessWidget {
  final Function onPressed;

  const _DeleteIcon({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onPressed();
      },
      shape: CircleBorder(),
      constraints: BoxConstraints(minWidth: 36, minHeight: 36),
      padding: EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }
}
