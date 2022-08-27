import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_text_field.dart';
import '../bloc/book_creator_bloc.dart';

class BookCreatorTitleAuthor extends StatelessWidget {
  const BookCreatorTitleAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Tytuł',
          onChanged: (String title) => _onTitleChanged(title, context),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Autor',
          onChanged: (String author) => _onAuthorChanged(author, context),
        ),
      ],
    );
  }

  void _onTitleChanged(String title, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventTitleChanged(title: title),
        );
  }

  void _onAuthorChanged(String author, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventAuthorChanged(author: author),
        );
  }
}
