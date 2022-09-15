import 'package:app/components/book_pages_editor_component.dart';
import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCreatorPages extends StatelessWidget {
  const BookCreatorPages({super.key});

  @override
  Widget build(BuildContext context) {
    final int readPagesAmount = context.select(
      (BookCreatorBloc bloc) => bloc.state.readPagesAmount,
    );
    final int allPagesAmount = context.select(
      (BookCreatorBloc bloc) => bloc.state.allPagesAmount,
    );

    return BookPagesEditorComponent(
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
      onReadPagesAmountChanged: (int amount) => _onReadPagesAmountChanged(
        amount,
        context,
      ),
      onAllPagesAmountChanged: (int amount) => _onAllPagesAmountChanged(
        amount,
        context,
      ),
    );
  }

  void _onReadPagesAmountChanged(int amount, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventReadPagesAmountChanged(readPagesAmount: amount),
        );
  }

  void _onAllPagesAmountChanged(int amount, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventAllPagesAmountChanged(allPagesAmount: amount),
        );
  }
}
