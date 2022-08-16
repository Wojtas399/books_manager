import 'package:app/config/themes/text_field_theme.dart';
import 'package:flutter/material.dart';

class BooksStatusDropdownFormField extends StatelessWidget {
  final Function(StatsBooksStatus status) onChanged;

  const BooksStatusDropdownFormField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: TextFieldTheme.basicTheme(
        label: 'Status',
      ),
      value: StatsBooksStatus.all,
      items: StatsBooksStatus.values
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(convertValueToText(value)),
            ),
          )
          .toList(),
      onChanged: (category) {
        onChanged(category as StatsBooksStatus);
      },
    );
  }

  String convertValueToText(StatsBooksStatus value) {
    switch (value) {
      case StatsBooksStatus.all:
        return 'Wszystkie';
      case StatsBooksStatus.read:
        return 'Czytane';
      case StatsBooksStatus.end:
        return 'Przeczytane';
      case StatsBooksStatus.paused:
        return 'Wstrzymane';
      case StatsBooksStatus.pending:
        return 'Oczekujące';
    }
  }
}

enum StatsBooksStatus {
  all,
  read,
  end,
  paused,
  pending,
}
