import 'package:flutter/material.dart';

import '../../models/action_sheet_action.dart';

class MaterialCustomActionSheet extends StatelessWidget {
  final String title;
  final List<ActionSheetAction> actions;

  const MaterialCustomActionSheet({
    super.key,
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          ...actions.asMap().entries.map(
                (MapEntry<int, ActionSheetAction> entry) =>
                    _createMaterialAction(
                  label: entry.value.label,
                  iconData: entry.value.iconData,
                  index: entry.key,
                  context: context,
                ),
              ),
          ListTile(
            title: const Text(
              'Anuluj',
              style: TextStyle(color: Colors.red),
            ),
            leading: const Icon(Icons.close, color: Colors.red),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _createMaterialAction({
    required String label,
    required IconData iconData,
    required int index,
    required BuildContext context,
  }) {
    return ListTile(
      title: Text(label),
      leading: Icon(iconData),
      onTap: () {
        Navigator.pop(context, index);
      },
    );
  }
}
