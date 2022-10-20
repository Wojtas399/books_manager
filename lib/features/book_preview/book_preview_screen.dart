import 'dart:typed_data';

import 'package:app/components/bloc_listener_component.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_after_reading_use_case.dart';
import 'package:app/domain/use_cases/day/add_new_read_book_to_user_days_use_case.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/features/book_preview/book_preview_arguments.dart';
import 'package:app/features/book_preview/components/book_preview_content.dart';
import 'package:app/providers/date_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewScreen extends StatelessWidget {
  final BookPreviewArguments arguments;

  const BookPreviewScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return _BookPreviewBlocProvider(
      bookId: arguments.bookId,
      initialBookImageData: arguments.imageData,
      child: const _BookPreviewBlocListener(
        child: BookPreviewContent(),
      ),
    );
  }
}

class _BookPreviewBlocProvider extends StatelessWidget {
  final String bookId;
  final Uint8List? initialBookImageData;
  final Widget child;

  const _BookPreviewBlocProvider({
    required this.bookId,
    required this.initialBookImageData,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BookPreviewBloc(
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        getBookByIdUseCase: GetBookByIdUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
        startReadingBookUseCase: StartReadingBookUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
        updateCurrentPageNumberAfterReadingUseCase:
            UpdateCurrentPageNumberAfterReadingUseCase(
          bookInterface: context.read<BookInterface>(),
          addNewReadBookToUserDaysUseCase: AddNewReadBookToUserDaysUseCase(
            dayInterface: context.read<DayInterface>(),
            dateProvider: DateProvider(),
          ),
        ),
        deleteBookUseCase: DeleteBookUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
        bookId: bookId,
        initialBookImageData: initialBookImageData,
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
    return BlocListenerComponent<BookPreviewBloc, BookPreviewState,
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
        _showInfoAboutPageActualisation(context);
        break;
      case BookPreviewBlocInfo.bookHasBeenDeleted:
        _showInfoAboutBookDeletion(context);
        break;
    }
  }

  void _onError(BookPreviewBlocError error, BuildContext context) {
    switch (error) {
      case BookPreviewBlocError.newCurrentPageNumberIsTooHigh:
        _showInfoAboutTooHighNumberOfNewCurrentPage(context);
        break;
      case BookPreviewBlocError.newCurrentPageIsLowerThanCurrentPage:
        _showInfoAboutNewPageNumberLowerThanCurrentPageNumber(context);
        break;
    }
  }

  void _showInfoAboutPageActualisation(BuildContext context) {
    context.read<DialogInterface>().showSnackBar(
          message: 'Pomyślnie zaktualizowano numer bieżącej strony',
        );
  }

  void _showInfoAboutBookDeletion(BuildContext context) {
    Navigator.pop(context);
    context.read<DialogInterface>().showSnackBar(
          message: 'Pomyślnie usunięto książkę',
        );
  }

  void _showInfoAboutTooHighNumberOfNewCurrentPage(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          title: 'Niepoprawny numer strony',
          info: 'Podany numer strony jest wyższy od liczby wszystkich stron...',
        );
  }

  void _showInfoAboutNewPageNumberLowerThanCurrentPageNumber(
    BuildContext context,
  ) {
    context.read<DialogInterface>().showInfoDialog(
          title: 'Niepoprawny numer strony',
          info:
              'Podany numer strony jest niższy od numeru poprzednio skończonej strony',
        );
  }
}
