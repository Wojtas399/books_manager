import 'package:app/components/search_field_component.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibrarySearchField extends StatelessWidget {
  const LibrarySearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 40,
        child: SearchFieldComponent(
          onChanged: (String value) => _onChanged(value, context),
        ),
      ),
    );
  }

  void _onChanged(String value, BuildContext context) {
    context.read<LibraryBloc>().add(
          LibraryEventSearchValueChanged(searchValue: value),
        );
  }
}
