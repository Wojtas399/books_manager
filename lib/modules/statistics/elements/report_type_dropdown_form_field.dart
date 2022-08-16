import 'package:app/config/themes/text_field_theme.dart';
import 'package:flutter/material.dart';

class ReportTypeDropdownFormField extends StatelessWidget {
  final Function(ReportType type) onChanged;

  const ReportTypeDropdownFormField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: TextFieldTheme.basicTheme(
        label: 'Raport',
      ),
      value: ReportType.weekly,
      items: ReportType.values
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(convertReportTypeToString(value)),
            ),
          )
          .toList(),
      onChanged: (category) {
        onChanged(category as ReportType);
      },
    );
  }

  String convertReportTypeToString(ReportType type) {
    switch (type) {
      case ReportType.weekly:
        return 'Tygodniowy';
      case ReportType.monthly:
        return 'Miesięczny';
      case ReportType.annual:
        return 'Roczny';
    }
  }
}

enum ReportType {
  weekly,
  monthly,
  annual,
}
