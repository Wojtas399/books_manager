import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/book_status_extension.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewBookStatus extends StatelessWidget {
  const BookPreviewBookStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final BookStatus? bookStatus = context.select(
      (BookPreviewBloc bloc) => bloc.state.bookStatus,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          bookStatus?.toIconData(),
          color: bookStatus?.toColor(),
        ),
        const SizedBox(width: 4),
        Text(
          bookStatus?.toUIText() ?? '',
          style: TextStyle(
            fontSize: 18,
            color: bookStatus?.toColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
