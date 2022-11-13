import 'package:app/components/custom_button_component.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/dialogs_build_context_extension.dart';
import 'package:app/extensions/string_extension.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewButton extends StatefulWidget {
  const BookPreviewButton({super.key});

  @override
  State<BookPreviewButton> createState() => _BookPreviewButtonState();
}

class _BookPreviewButtonState extends State<BookPreviewButton> {
  @override
  Widget build(BuildContext context) {
    final BookStatus? bookStatus = context.select(
      (BookPreviewBloc bloc) => bloc.state.bookStatus,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CustomButton(
        label: bookStatus != null ? _getButtonLabel(bookStatus) : '',
        onPressed: bookStatus != null ? () => _onPressed(bookStatus) : null,
      ),
    );
  }

  String _getButtonLabel(BookStatus bookStatus) {
    switch (bookStatus) {
      case BookStatus.unread:
        return 'Rozpocznij czytanie';
      case BookStatus.inProgress:
        return 'Zaktualizuj bieżącą stronę';
      case BookStatus.finished:
        return 'Czytaj ponownie';
    }
  }

  Future<void> _onPressed(BookStatus bookStatus) async {
    switch (bookStatus) {
      case BookStatus.unread:
        _startReading();
        break;
      case BookStatus.inProgress:
        await _updateCurrentPage();
        break;
      case BookStatus.finished:
        _startReadingFromBeginning();
        break;
    }
  }

  void _startReading() {
    context.read<BookPreviewBloc>().add(
          const BookPreviewEventStartReading(),
        );
  }

  Future<void> _updateCurrentPage() async {
    final int? newCurrentPageNumber = await _askForNewCurrentPageNumber();
    if (newCurrentPageNumber != null && mounted) {
      context.read<BookPreviewBloc>().add(
            BookPreviewEventUpdateCurrentPageNumber(
              currentPageNumber: newCurrentPageNumber,
            ),
          );
    }
  }

  void _startReadingFromBeginning() {
    context.read<BookPreviewBloc>().add(
          const BookPreviewEventStartReading(fromBeginning: true),
        );
  }

  Future<int?> _askForNewCurrentPageNumber() async {
    final BookPreviewBloc bookPreviewBloc = context.read<BookPreviewBloc>();
    final int? currentPageNumber = bookPreviewBloc.state.readPagesAmount;
    final String? numberInString = await context.askForValue(
      title: 'Bieżąca strona',
      message: 'Podaj nowy numer bieżącej strony',
      initialValue: '${currentPageNumber ?? 0}',
      acceptLabel: 'Zapisz',
    );
    return numberInString?.toInt();
  }
}
