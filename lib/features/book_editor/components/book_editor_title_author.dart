import 'package:app/components/custom_text_field_component.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookEditorTitleAuthor extends StatelessWidget {
  const BookEditorTitleAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TitleTextField(),
        const SizedBox(height: 16),
        _AuthorTextField(),
      ],
    );
  }
}

class _TitleTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (BookEditorBloc bloc) => bloc.state.status,
    );
    final String? title = context.select(
      (BookEditorBloc bloc) => bloc.state.title,
    );
    if (blocStatus is BlocStatusComplete) {
      _controller.text = title ?? '';
    }

    return CustomTextField(
      label: 'Tytuł',
      controller: _controller,
      onChanged: (String value) => _onChanged(value, context),
    );
  }

  void _onChanged(String value, BuildContext context) {
    context.read<BookEditorBloc>().add(
          BookEditorEventTitleChanged(title: value),
        );
  }
}

class _AuthorTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (BookEditorBloc bloc) => bloc.state.status,
    );
    final String? author = context.select(
      (BookEditorBloc bloc) => bloc.state.author,
    );
    if (blocStatus is BlocStatusComplete) {
      _controller.text = author ?? '';
    }

    return CustomTextField(
      label: 'Autor',
      controller: _controller,
      onChanged: (String value) => _onChanged(value, context),
    );
  }

  void _onChanged(String value, BuildContext context) {
    context.read<BookEditorBloc>().add(
          BookEditorEventAuthorChanged(author: value),
        );
  }
}
