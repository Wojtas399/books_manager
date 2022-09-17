import 'package:app/domain/entities/book.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingContent extends StatelessWidget {
  const ReadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book> booksInProgress = context.select(
      (ReadingBloc bloc) => bloc.state.booksInProgress,
    );

    return Column(
      children: booksInProgress.map((Book book) => Text(book.title)).toList(),
    );
  }
}
