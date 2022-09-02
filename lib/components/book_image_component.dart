import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BookImageComponent extends StatelessWidget {
  final Image? image;
  final double? bookIconSize;

  const BookImageComponent({
    super.key,
    required this.image,
    this.bookIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return image ?? _BookIcon(iconSize: bookIconSize);
  }
}

class _BookIcon extends StatelessWidget {
  final double? iconSize;

  const _BookIcon({this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Icon(
      MdiIcons.bookOpenPageVariantOutline,
      color: Colors.grey.withOpacity(0.3),
      size: iconSize,
    );
  }
}
