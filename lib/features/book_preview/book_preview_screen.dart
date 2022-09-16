import 'package:app/components/custom_bloc_listener.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_in_book_use_case.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/features/book_preview/components/book_preview_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewScreen extends StatelessWidget {
  final String bookId;

  const BookPreviewScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return _BookPreviewBlocProvider(
      bookId: bookId,
      child: const _BookPreviewBlocListener(
        child: BookPreviewContent(),
      ),
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
        startReadingBookUseCase: StartReadingBookUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
        updateCurrentPageNumberInBookUseCase:
            UpdateCurrentPageNumberInBookUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
        deleteBookUseCase: DeleteBookUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      )..add(
          BookPreviewEventInitialize(bookId: bookId),
        ),
      child: child,
    );
  }
}

class _BookPreviewBlocListener extends StatelessWidget {
  final Widget child;

  const _BookPreviewBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomBlocListener<BookPreviewBloc, BookPreviewState,
        BookPreviewBlocInfo, BookPreviewBlocError>(
      onCompletionInfo: (BookPreviewBlocInfo info) => _onCompletionInfo(
        info,
        context,
      ),
      onError: (BookPreviewBlocError error) => _onError(error, context),
      child: child,
    );
  }

  void _onCompletionInfo(BookPreviewBlocInfo info, BuildContext context) {
    switch (info) {
      case BookPreviewBlocInfo.currentPageNumberHasBeenUpdated:
        _onCurrentPageUpdate(context);
        break;
      case BookPreviewBlocInfo.bookHasBeenDeleted:
        _onBookDeletion(context);
        break;
    }
  }

  void _onError(BookPreviewBlocError error, BuildContext context) {
    switch (error) {
      case BookPreviewBlocError.newCurrentPageNumberIsTooHigh:
        _onTooHighNumberOfNewCurrentPage(context);
        break;
    }
  }

  void _onCurrentPageUpdate(BuildContext context) {
    context.read<DialogInterface>().showSnackBar(
          message: 'Pomyślnie zaktualizowano numer bieżącej strony',
        );
  }

  void _onBookDeletion(BuildContext context) {
    Navigator.pop(context);
    context.read<DialogInterface>().showSnackBar(
          message: 'Pomyślnie usunięto książkę',
        );
  }

  void _onTooHighNumberOfNewCurrentPage(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          title: 'Niepoprawny numer strony',
          info: 'Podany numer strony jest wyższy od liczby wszystkich stron...',
        );
  }
}
