import 'package:app/config/themes/material_text_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchFieldComponent extends StatelessWidget {
  final Function(String value)? onChanged;

  const SearchFieldComponent({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: MaterialTextFieldTheme.filled(
        iconData: MdiIcons.magnify,
        placeholder: 'Szukaj...',
      ),
      onChanged: onChanged,
    );
  }
}
