import 'package:app/core/book/book_model.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:flutter/material.dart';

class BookDetailsFunctionalButton extends StatelessWidget {
  final Stream<BookStatus> bookStatus$;
  final Function onClickFunctionalButton;

  const BookDetailsFunctionalButton({
    required this.bookStatus$,
    required this.onClickFunctionalButton,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bookStatus$,
      builder: (_, AsyncSnapshot<BookStatus> snapshot) {
        BookStatus? status = snapshot.data;
        return Container(
          width: double.infinity,
          child: MediumGreenButton(
            text: _convertStatusToButtonText(status),
            onPressed: () {
              onClickFunctionalButton();
            },
            icon: _convertStatusToIcon(status),
          ),
        );
      },
    );
  }

  String _convertStatusToButtonText(BookStatus? status) {
    switch (status) {
      case BookStatus.pending:
        return 'Czytaj';
      case BookStatus.read:
        return 'Wstrzymaj';
      case BookStatus.end:
        return 'Czytaj ponownie';
      case BookStatus.paused:
        return 'Wznów';
      default:
        return 'Czytaj';
    }
  }

  IconData _convertStatusToIcon(BookStatus? status) {
    switch (status) {
      case BookStatus.pending:
        return Icons.play_lesson_rounded;
      case BookStatus.read:
        return Icons.pause_rounded;
      case BookStatus.end:
        return Icons.replay_rounded;
      case BookStatus.paused:
        return Icons.play_arrow_rounded;
      default:
        return Icons.play_lesson_rounded;
    }
  }
}
