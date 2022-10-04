import 'package:flutter/material.dart';

class CalendarDaysShortcuts extends StatelessWidget {
  const CalendarDaysShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _ShortcutsOfTheDays(),
        ),
      ),
    );
  }
}

class _ShortcutsOfTheDays extends StatelessWidget {
  final List<String> shortcuts = [
    'Pon',
    'Wt',
    'Śr',
    'Czw',
    'Pt',
    'Sob',
    'Ndz',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: shortcuts
          .map((String shortcut) => _ShortcutText(shortcutText: shortcut))
          .toList(),
    );
  }
}

class _ShortcutText extends StatelessWidget {
  final String shortcutText;

  const _ShortcutText({required this.shortcutText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        shortcutText,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
