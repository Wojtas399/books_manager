import 'package:app/components/custom_bloc_listener.dart';
import 'package:app/config/navigation.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:app/features/book_editor/components/book_editor_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookEditorScreen extends StatelessWidget {
  final String bookId;

  const BookEditorScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return _BookEditorBlocProvider(
      bookId: bookId,
      child: const _BookEditorBlocListener(
        child: BookEditorContent(),
      ),
    );
  }
}

class _BookEditorBlocProvider extends StatelessWidget {
  final String bookId;
  final Widget child;

  const _BookEditorBlocProvider({
    required this.bookId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BookEditorBloc(
        getBookByIdUseCase: GetBookByIdUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
        updateBookUseCase: UpdateBookUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      )..add(
          BookEditorEventInitialize(bookId: bookId),
        ),
      child: child,
    );
  }
}

class _BookEditorBlocListener extends StatelessWidget {
  final Widget child;

  const _BookEditorBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomBlocListener<BookEditorBloc, BookEditorState,
        BookEditorBlocInfo, dynamic>(
      onCompletionInfo: (BookEditorBlocInfo? blocInfo) => _onCompletionInfo(
        blocInfo,
        context,
      ),
      child: child,
    );
  }

  void _onCompletionInfo(
    BookEditorBlocInfo? blocInfo,
    BuildContext context,
  ) {
    if (blocInfo != null) {
      switch (blocInfo) {
        case BookEditorBlocInfo.bookHasBeenUpdated:
          _onBookUpdate(context);
          break;
      }
    }
  }

  void _onBookUpdate(BuildContext context) {
    Navigation.moveBack();
    context.read<DialogInterface>().showSnackBar(
          message: 'Pomyślnie zaktualizowano książkę',
        );
  }
}
