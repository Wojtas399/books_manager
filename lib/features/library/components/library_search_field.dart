import 'package:app/components/search_field_component.dart';
import 'package:flutter/material.dart';

class LibrarySearchField extends StatelessWidget {
  const LibrarySearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: SizedBox(
        height: 40,
        child: SearchFieldComponent(),
      ),
    );
  }
}
