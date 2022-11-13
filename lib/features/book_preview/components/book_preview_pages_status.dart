import 'package:app/components/pages_progress_bar_component.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/book_status_extension.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewPagesStatus extends StatelessWidget {
  const BookPreviewPagesStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final BookStatus? bookStatus = context.select(
      (BookPreviewBloc bloc) => bloc.state.bookStatus,
    );
    final int? readPagesAmount = context.select(
      (BookPreviewBloc bloc) => bloc.state.readPagesAmount,
    );
    final int? allPagesAmount = context.select(
      (BookPreviewBloc bloc) => bloc.state.allPagesAmount,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PagesProgressBarComponent(
        readPagesAmount: readPagesAmount ?? 0,
        allPagesAmount: allPagesAmount ?? 0,
        progressBarColor: bookStatus?.toColor(),
      ),
    );
  }
}
