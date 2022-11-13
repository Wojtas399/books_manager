import 'package:app/components/book_pages_editor_component.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookEditorPages extends StatelessWidget {
  const BookEditorPages({super.key});

  @override
  Widget build(BuildContext context) {
    final int? readPagesAmount = context.select(
      (BookEditorBloc bloc) => bloc.state.readPagesAmount,
    );
    final int? allPagesAmount = context.select(
      (BookEditorBloc bloc) => bloc.state.allPagesAmount,
    );

    return BookPagesEditorComponent(
      readPagesAmount: readPagesAmount ?? 0,
      allPagesAmount: allPagesAmount ?? 0,
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
    context.read<BookEditorBloc>().add(
          BookEditorEventReadPagesAmountChanged(readPagesAmount: amount),
        );
  }

  void _onAllPagesAmountChanged(int amount, BuildContext context) {
    context.read<BookEditorBloc>().add(
          BookEditorEventAllPagesAmountChanged(allPagesAmount: amount),
        );
  }
}
