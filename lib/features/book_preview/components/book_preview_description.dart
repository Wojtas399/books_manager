import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewDescription extends StatelessWidget {
  const BookPreviewDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(),
          SizedBox(height: 8),
          _Author(),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final String? title = context.select(
      (BookPreviewBloc bloc) => bloc.state.title,
    );

    return Text(
      title ?? '',
      maxLines: 4,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _Author extends StatelessWidget {
  const _Author();

  @override
  Widget build(BuildContext context) {
    final String? author = context.select(
      (BookPreviewBloc bloc) => bloc.state.author,
    );

    return Text(
      author ?? '',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
