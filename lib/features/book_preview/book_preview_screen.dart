import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/features/book_preview/components/book_preview_content.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewScreen extends StatelessWidget {
  final String bookId;

  const BookPreviewScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return _BookPreviewBlocProvider(
      bookId: bookId,
      child: const BookPreviewContent(),
    );
  }
}

class _BookPreviewBlocProvider extends StatelessWidget {
  final String bookId;
  final Widget child;

  const _BookPreviewBlocProvider({
    required this.bookId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BookPreviewBloc(
        getBookByIdUseCase: GetBookByIdUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      )..add(
          BookPreviewEventInitialize(bookId: bookId),
        ),
      child: child,
    );
  }
}
